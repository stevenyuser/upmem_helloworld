# directories
DPU_DIR := dpu
HOST_DIR := host

BUILDDIR ?= bin

HOST_TARGET := ${BUILDDIR}/host_code
DPU_TARGET := ${BUILDDIR}/dpu_code

HOST_SOURCES := $(wildcard ${HOST_DIR}/*.c)
DPU_SOURCES := $(wildcard ${DPU_DIR}/*.c)
######

# upmem settings
NR_TASKLETS ?= 1
NR_DPUS ?= 1 
ENERGY ?= 0
######

.PHONY: all clean test

__dirs := $(shell mkdir -p ${BUILDDIR})

COMMON_FLAGS := 
HOST_FLAGS := ${COMMON_FLAGS} -std=c99 `dpu-pkg-config --cflags --libs dpu`
DPU_FLAGS := ${COMMON_FLAGS}

all: ${HOST_TARGET} ${DPU_TARGET}


${HOST_TARGET}: ${HOST_SOURCES}
	$(CC) -o $@ ${HOST_SOURCES} ${HOST_FLAGS}

${DPU_TARGET}: ${DPU_SOURCES}
	dpu-upmem-dpurte-clang ${DPU_FLAGS} -o $@ ${DPU_SOURCES}

clean:
	$(RM) -r $(BUILDDIR)

test: all
	./${HOST_TARGET}