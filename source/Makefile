.PHONY: all clean distclean install

obj-m := iptable_raw.o xt_comment.o xt_connmark.o
kernel_mod = iptable_raw.ko xt_comment.ko xt_connmark.ko
kernel_src = iptable_raw.c xt_comment.c xt_connmark.c

CROSS_COMPILE=/usr/local/x86_64-pc-linux-gnu/bin/x86_64-pc-linux-gnu-
GCC=$(CROSS_COMPILE)gcc
KSRC=/usr/local/x86_64-pc-linux-gnu/x86_64-pc-linux-gnu/sys-root/usr/lib/modules/DSM-${DSM_VER}/build
SOURCE_DIR=/source/${PACKAGE_NAME}

$(kernel_mod):
	make -C $(KSRC) M=$(PWD) ARCH=$(ARCH) CC=$(GCC) modules

all: $(kernel_mod)

clean:
	rm -f $(SOURCE_DIR)/*.o $(SOURCE_DIR)/*.ko $(SOURCE_DIR)/*.mod.c $(SOURCE_DIR)/modules.order $(SOURCE_DIR)/Module.symvers $(SOURCE_DIR)/Module.markers $(SOURCE_DIR)/modules.builtin $(SOURCE_DIR)/.iptable_raw* $(SOURCE_DIR)/.xt_comment* $(SOURCE_DIR)/.xt_connmark* $(SOURCE_DIR)/.*.cmd

distclean: clean
	rm -f $(DESTDIR)/*.ko

install: all
	cp -f $(kernel_mod) $(DESTDIR)
