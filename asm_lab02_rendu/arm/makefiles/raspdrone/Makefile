# Flags #    

CFLAGS  = -fno-builtin -I../../../u-boot/include -I../../../u-boot/arch/arm/include -D__KERNEL__ -I ./ -marm -g
LDFLAGS = -L. -ldriver -T asm.lds



# Toolchain #

# Define the toolchain prefix
TOOL_PREFIX := arm-linux-gnueabihf

# Toolchain binaries
AR      = $(TOOL_PREFIX)-ar
CC      = $(TOOL_PREFIX)-gcc
LD      = $(TOOL_PREFIX)-ld
OBJCOPY = $(TOOL_PREFIX)-objcopy



# Objects #

# Target executable name
TARGET = raspdrone

# Source files
SRCS_C = engine.c autopilot.c gyroscope.c motor.c navigation.c pwm_drone.c camera.c
SRCS_S = crt0.S

# Object files
OBJS_C = $(SRCS_C:.c=.o)
OBJS_S = $(SRCS_S:.S=.o)
OBJS   = $(OBJS_C) $(OBJS_S)

# Library object files and library name
LIB_OBJS = motor.o gyroscope.o camera.o
LIB     = libdriver.a



# Build targets #


.PHONY: all checklib clean
all: checklib $(TARGET) $(TARGET).bin


$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)

# Compile C source files into object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Compile assembler source files into object files
%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

$(LIB): $(LIB_OBJS)
	$(AR) -r $@ $^

checklib: $(LIB)


$(TARGET).bin: $(TARGET)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f *.o $(TARGET) $(TARGET).bin $(LIB)



# Dependencies #
autopilot.o: autopilot.h gyroscope.h navigation.h
camera.o: camera.h
gyroscope.o: gyroscope.h
motor.o: motor.h
navigation.o: navigation.h gyroscope.h camera.h
pwm_drone.o: pwm_drone.h
engine.o: motor.h autopilot.h camera.h gyroscope.h