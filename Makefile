BUILD_DIR=builds
GAME_DIR=game
GAME_FILE_NAME=Soviet_VS_Asteroids
COMPILED_GAME_FILE=$(BUILD_DIR)/game.love

LINUX_DIR=$(BUILD_DIR)/Linux
MAC_DIR=$(BUILD_DIR)/Mac
WINx64_DIR=$(BUILD_DIR)/Windows_x64
WINx86_DIR=$(BUILD_DIR)/Windows_x86

LINUX_EXE=$(LINUX_DIR)/$(GAME_FILE_NAME)
MAC_EXE=$(MAC_DIR)/$(GAME_FILE_NAME).app
WINx64_EXE=$(WINx64_DIR)/$(GAME_FILE_NAME)_x64.exe
WINx86_EXE=$(WINx86_DIR)/$(GAME_FILE_NAME)_x86.exe

TMP_DIR=tmp
LIN_TMP_DIR=$(GAME_FILE_NAME)_lin
MAC_TMP_DIR=$(GAME_FILE_NAME)_mac
WINx64_TMP_DIR=$(GAME_FILE_NAME)_win_x64
WINx86_TMP_DIR=$(GAME_FILE_NAME)_win_x86

all:	archive

archive:	build archive-linux archive-mac archive-win-x64 archive-win-x86

archive-linux:	build-linux
	mkdir -p $(TMP_DIR)/$(LIN_TMP_DIR)
	cp $(LINUX_EXE) $(TMP_DIR)/$(LIN_TMP_DIR)
	cd $(TMP_DIR); zip -r $(LIN_TMP_DIR).zip $(LIN_TMP_DIR)
	mv $(TMP_DIR)/$(LIN_TMP_DIR).zip .
	rm -rf $(TMP_DIR)

archive-mac:	build-mac
	mkdir -p $(TMP_DIR)/$(MAC_TMP_DIR)
	cp -r $(MAC_EXE) $(TMP_DIR)/$(MAC_TMP_DIR)
	cd $(TMP_DIR); zip -r $(MAC_TMP_DIR).zip $(MAC_TMP_DIR)
	mv $(TMP_DIR)/$(MAC_TMP_DIR).zip .
	rm -rf $(TMP_DIR)

archive-win-x64:	build-win-x64
	mkdir -p $(TMP_DIR)/$(WINx64_TMP_DIR)
	cp $(WINx64_EXE) $(TMP_DIR)/$(WINx64_TMP_DIR)
	cp $(WINx64_DIR)/*.dll $(TMP_DIR)/$(WINx64_TMP_DIR)
	cd $(TMP_DIR); zip -r $(WINx64_TMP_DIR).zip $(WINx64_TMP_DIR)
	mv $(TMP_DIR)/$(WINx64_TMP_DIR).zip .
	rm -rf $(TMP_DIR)

archive-win-x86:	build-win-x86
	mkdir -p $(TMP_DIR)/$(WINx86_TMP_DIR)
	cp $(WINx86_EXE) $(TMP_DIR)/$(WINx86_TMP_DIR)
	cp $(WINx86_DIR)/*.dll $(TMP_DIR)/$(WINx86_TMP_DIR)
	cd $(TMP_DIR); zip -r $(WINx86_TMP_DIR).zip $(WINx86_TMP_DIR)
	mv $(TMP_DIR)/$(WINx86_TMP_DIR).zip .
	rm -rf $(TMP_DIR)

build:	compile-game build-linux build-mac build-win-x64 build-win-x86

compile-game:
	cd $(GAME_DIR); zip -r ../$(COMPILED_GAME_FILE) *

build-linux:	compile-game
	echo "Building for Linux..."
	cat $(LINUX_DIR)/love $(COMPILED_GAME_FILE) > $(LINUX_EXE) && chmod +x $(LINUX_EXE)

build-mac:	compile-game
	echo "Building for Mac OS..."
	cp -r $(MAC_DIR)/love.app $(MAC_EXE) && cp $(COMPILED_GAME_FILE) $(MAC_EXE)/Contents/Resources/

build-win-x64:	compile-game
	echo "Building for Windows x64..."
	cat $(WINx64_DIR)/love.exe $(COMPILED_GAME_FILE) > $(WINx64_EXE)

build-win-x86:	compile-game
	echo "Building for Windows x86..."
	cat $(WINx86_DIR)/love.exe $(COMPILED_GAME_FILE) > $(WINx86_EXE)

clear:
	rm -rf $(COMPILED_GAME_FILE) $(LINUX_EXE) $(MAC_EXE) $(WINx64_EXE) $(WINx86_EXE) $(TMP_DIR) *.zip
