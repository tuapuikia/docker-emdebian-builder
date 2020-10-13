all: multistrap


.PHONY: multistrap docker-image docker-shell build builder-shell release clean re


#multistrap: chroot build qemu-arm-static
multistrap: chroot build
	docker run -it --privileged --rm -v $(PWD)/chroot:/chroot -v $(PWD)/multistrap.conf:/multistrap.conf local/ubuntu-builder
	mkdir -p chroot/usr/local/bin/
	#cp -f qemu-arm-static chroot/usr/local/bin/
	#chmod +x chroot/usr/local/bin/qemu-arm-static
	if [ ! -f chroot/bin/sh ]; then ln -s busybox chroot/bin/sh; fi
	sudo du -hs chroot


docker-image: chroot
	echo "FROM scratch" > chroot/Dockerfile
	echo "ADD . /" >> chroot/Dockerfile
	echo "RUN /bin/busybox --install -s" >> chroot/Dockerfile
	echo "CMD /bin/sh" >> chroot/Dockerfile
	docker build -t emdebian chroot


docker-shell: docker-image
	docker run -it --rm emdebian


build:
	docker build -t local/ubuntu-builder .


builder-shell: build
	docker run -it --rm -v $(PWD)/chroot:/chroot -v $(PWD)/multistrap.conf:/multistrap.conf local/ubuntu-builder bash


release:
	sudo tar -C chroot -c . | docker import - tuapuikia/focal:latest && docker push tuapuikia/focal:latest


clean:
	sudo rm -rf chroot
	docker rmi local/ubuntu-builder


re: clean multistrap


# file-based
chroot:
	mkdir -p chroot

#qemu-arm-static:
#	wget --no-check-certificate https://github.com/armbuild/qemu-user-static/raw/master/x86_64/qemu-arm-static -O $@
