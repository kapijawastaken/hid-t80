CONFIG_MODULE_SIG=n

ifeq ($(KERNELRELEASE),)
KERNELDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)

clean:
	rm -rf *.mk .tmp_versions Module.symvers *.mod.c *.o *.ko .*.cmd Module.markers modules.order *.a *.mod

load:
	sudo insmod hid-t80.ko

unload:
	sudo rmmod hid-t80

reload:
	sudo rmmod hid-t80
	sudo insmod hid-t80.ko

install: default
	sudo insmod hid-t80.ko || true
	sudo mkdir -p /lib/modules/$(shell uname -r)/kernel/drivers/hid || true
	sudo cp -f ./hid-t80.ko /lib/modules/$(shell uname -r)/kernel/drivers/hid || true
	@/bin/echo -e "hid-t80" | sudo tee -a /etc/modules > /dev/null || true
	sudo depmod -a

uninstall:
	sudo rmmod hid-t80 || true
	sudo rm -f /lib/modules/$(shell uname -r)/kernel/drivers/hid/hid-t80.ko || true
	sudo depmod -a

else
	obj-m := hid-t80.o
endif
