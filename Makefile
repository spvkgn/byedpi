TARGET = ciadpi

CPPFLAGS = -D_DEFAULT_SOURCE
CFLAGS += -I. -std=c99 -Wall -Wno-unused -O2
WIN_LDFLAGS = -lws2_32 -lmswsock

SRC = packets.c main.c conev.c proxy.c desync.c mpool.c extend.c
WIN_SRC = win_service.c

OBJ = $(SRC:.c=.o)
WIN_OBJ = $(WIN_SRC:.c=.o)

PREFIX := /usr/local
INSTALL_DIR := $(DESTDIR)$(PREFIX)/bin/

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) -o $(TARGET) $(OBJ) $(LDFLAGS)

darwin: $(OBJ)
	$(CC) -o $(TARGET)-arm64 -target arm64-apple-macos10.8 $(OBJ) $(LDFLAGS)
	$(CC) -o $(TARGET)-x64 -target x86_64-apple-macos10.8 $(OBJ) $(LDFLAGS)
	lipo -create -output $(TARGET) $(TARGET)-arm64 $(TARGET)-x64
	rm -f $(TARGET)-arm64 $(TARGET)-x64

windows: $(OBJ) $(WIN_OBJ)
	$(CC) -o $(TARGET).exe $(OBJ) $(WIN_OBJ) $(WIN_LDFLAGS)

.c.o:
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $<

clean:
	rm -f $(TARGET) $(TARGET).exe $(OBJ) $(WIN_OBJ)

install: $(TARGET)
	mkdir -p $(INSTALL_DIR)
	install -m 755 $(TARGET) $(INSTALL_DIR)
