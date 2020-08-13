#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import platform
import subprocess
import sys
import shutil

try:
    input = raw_input
except NameError:
    pass

try:
    import argparse
except ImportError as e:
    print(u"{0},\t use 'pip' to install that package".format(
        e.message), file=sys.stderr)
    sys.exit(1)

try:
    from subprocess import DEVNULL
except ImportError:
    DEVNULL = open(os.devnull, 'wb')


class FileInfo(object):

    def __init__(self, src, dst, bak):
        self.src = src
        self.dst = dst
        self.bak = bak

    @classmethod
    # always return an abspath
    def apply(cls, src, bakdir):
        src_name = os.path.basename(src)
        dst = os.path.join(DST_DIR, '.' + src_name[1:])  # replace '_' with '.'
        bak = os.path.join(bakdir, PREFIX + os.path.basename(dst))
        return cls(src, dst, bak)

    def __repr__(self):
        return 'src={}, dst={}, bak={}'.format(self.src, self.dst, self.bak)


class MLevel(object):
    check = u'\u2714'
    cross = u'\u2717'
    other = u'\u25CB'


CUR_DIR = os.path.abspath(os.path.dirname(__file__))
BAK_DIR = os.path.join(CUR_DIR, ".BAK")
PLT = platform.system()  # Darwin/Linux
SUPPORTED_PLT = ['Darwin', 'Linux']
if PLT not in SUPPORTED_PLT:
    print(u"Unknown Platform: {}, supported: {}".format(
        PLT, SUPPORTED_PLT), file=sys.stderr)
    sys.exit(1)
# FreeBSD /home is a symlink to /usr/home
DST_DIR = os.path.realpath(os.path.expandvars("$HOME"))

PREFIX = '_bak'

# -----------------------------------------------------------------------------


def _git_get(git_repo, dst):
    if not os.path.isdir(dst):
        cmd_str = "git clone --depth 1 {} {}".format(git_repo, dst)
        subprocess.call(cmd_str.split())


def _config_nvim():
    PLUG_URI = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    PLUG_PATH = os.path.join(PLT, "_local/share/nvim/site/autoload/plug.vim")
    print(u'Press [ENTER] to ignore errors (if any) during install')
    dl_cmd = "curl -fLo {} --create-dirs {}".format(PLUG_PATH, PLUG_URI)
    subprocess.call(dl_cmd.split())
    cmd_str = "nvim -c PlugInstall -c qa"
    subprocess.call(cmd_str.split())


def _yn_choice(message, default='y'):
    choices = 'Y/n' if default.lower() in ('y', 'yes') else 'y/N'
    choice = input("{} ({})".format(message, choices))
    values = ('y', 'yes', '') if default == 'y' else ('y', 'yes')
    return choice.strip().lower() in values


def _get_src_files(root):
    src_files = []
    plt_root = os.path.join(root, PLT)
    for r in [root, plt_root]:
        for src in os.listdir(r):
            if src.startswith('_'):
                src_files.append(os.path.join(r, src))
    return src_files


def _ensure_bakdir(bakdir):
    if not os.path.exists(bakdir):
        print(u"backup dir [{}] doesn't exist".format(bakdir), file=sys.stderr)
        choice = _yn_choice("Would you like to create it?")
        if choice:
            try:
                os.makedirs(bakdir)
            except os.error as e:
                print(e, file=sys.stderr)
                sys.exit(1)
        else:
            print(u"backup aborted, exit", file=sys.stderr)
            sys.exit(1)
    print(u"backup dir is: {}".format(bakdir))


# ------------------------------------------------------------------------

def parse_args():
    parser = argparse.ArgumentParser(
        description="bootstrap for dotfiles configuration", formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument(
        "-c", "--config",
        dest="config",
        nargs="+",
        choices=["nvim"],
        help="some special configurations")
    parser.add_argument("-r", "--recover", dest="recover", action="store_true", required=False,
                        help="restore the original dotfiles")
    parser.add_argument("-n", "--dryrun", dest="dryrun", action="store_true", required=False,
                        help="print the effect rather than run it")
    parser.add_argument(
        "-d", "--dir",
        dest="bakdir",
        default=BAK_DIR,
        required=False,
        help="restore directory")
    return parser.parse_args()


# dot: dst->backdir, src->dst(symlink)
# recover: dst->xxx(unlink), backdir->dst

def __dot_mark(finfo):
    if not os.path.exists(finfo.dst):
        mark = MLevel.check
    elif os.path.islink(finfo.dst):
        mark = MLevel.other
    else:
        mark = MLevel.cross
    return mark


def _dot_dryrun(finfo):
    mark = __dot_mark(finfo)
    rel_src = os.path.relpath(finfo.src, DST_DIR)
    print(u"{0:<60} ⇒ \t[{m}] {1:<50}".format(rel_src, finfo.dst, m=mark))


def _dot(finfo):
    dst_exist = os.path.exists(finfo.dst) or os.path.islink(finfo.dst)
    if dst_exist:
        print(u"dst={0:<60} bak={1}".format(
            finfo.dst, finfo.bak), file=sys.stderr)
        if os.path.islink(finfo.dst):
            os.unlink(finfo.dst)
        else:
            shutil.move(finfo.dst, finfo.bak)
    rel_src = os.path.relpath(finfo.src, DST_DIR)
    os.symlink(rel_src, finfo.dst)


def __recover_mark(finfo):
    if os.path.exists(finfo.bak) and not os.path.islink(finfo.bak):
        mark = MLevel.check
    else:
        mark = MLevel.cross
    return mark


def _recover_dryrun(finfo):
    mark = __recover_mark(finfo)
    rel_bak = os.path.relpath(finfo.bak, CUR_DIR)
    print(u"{0:<60} ->\t[{m}] {1:<50}".format(rel_bak, finfo.dst, m=mark))


def _recover(finfo):
    try:
        os.unlink(finfo.dst)
    except OSError as e:
        # dotfile in CUR_DIR may not exists in DST_DIR
        print(u"unlink Error {}".format(e), file=sys.stderr)
    bak_exist = os.path.exists(finfo.bak) and not os.path.islink(finfo.bak)
    if bak_exist:
        os.rename(finfo.bak, finfo.dst)
    else:
        print(u"no backup for: {0}".format(finfo.dst), file=sys.stderr)


def dot_general(args):
    if not args.dryrun:
        _ensure_bakdir(args.bakdir)
    src_files = _get_src_files(CUR_DIR)
    if not args.recover:
        fn = _dot_dryrun if args.dryrun else _dot
    else:
        fn = _recover_dryrun if args.dryrun else _recover
    for src in src_files:
        finfo = FileInfo.apply(src, args.bakdir)
        fn(finfo)


def main():
    args = parse_args()
    if args.config:
        for config in set(args.config):
            eval('_config_' + config)()
    else:
        dot_general(args)


if __name__ == '__main__':
    main()
