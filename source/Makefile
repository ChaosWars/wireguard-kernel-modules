.PHONY: all clean distclean install

obj-m := iptable_raw.o xt_comment.o xt_connmark.o
kernel_mod := iptable_raw.ko xt_comment.ko xt_connmark.ko
kernel_src := iptable_raw.c xt_comment.c xt_connmark.c

KSRC=/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-$(DSMVERSION)/build
SOURCE_DIR=/source/$(PACKAGE_NAME)

$(kernel_mod):
	make -C $(KSRC) M=$(PWD) modules

all: $(kernel_mod)

clean:
	make -C $(KSRC) M=$(PWD) clean

distclean: clean
	rm -f $(DESTDIR)/wireguardkernelmodules

install: all
	mkdir -p $(DESTDIR)/wireguardkernelmodules
	install $(kernel_mod) $(DESTDIR)/wireguardkernelmodules
