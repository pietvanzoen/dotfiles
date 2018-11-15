
if ! pgrep -f "termux-chroot" >/dev/null ; then echo "[Starting chroot...]" && termux-chroot; else echo "[chroot is running]"; fi

if ! pgrep "sshd" >/dev/null ; then echo "[Starting sshd...]" && sshd && echo "[OK]"; else echo "[ssh is running]"; fi
