SRCDIR := src
OBJDIR := obj
ICODIR := ico
SRC := $(wildcard $(SRCDIR)/*.cpp)
OBJ := $(patsubst $(SRCDIR)/%.cpp, $(OBJDIR)/%.o, $(SRC))
ICO := $(ICODIR)/ico.res
CXXFLAGS := -std=c++17 -s -O2 -mwindows
LDFLAGS := -lsfml-graphics-s -lsfml-window-s -lsfml-system-s -lopengl32 -lfreetype -lwinmm -lgdi32 -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread -Wl,-Bdynamic
INCFLAGS := -I ./SFML-2.5.1/include -Iinclude
LIBFLAGS := -L ./SFML-2.5.1/lib
DEFINES := -DSFML_STATIC

.PHONY: test create clean

all: create bin/bongo.exe
	xcopy img\ bin\img /E /H /C /I
	xcopy font\ bin\font /E /H /C /I
	xcopy ico\ bin\ico /E /H /C /I
	xcopy config.json bin\

	mingw32-make test

bin/bongo.exe: $(OBJ) $(ICO)
	$(CXX) -o $@ $^ $(DEFINES) $(INCFLAGS) $(LIBFLAGS) $(CXXFLAGS) $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp
	$(CXX) -c -o $@ $^ $(DEFINES) $(INCFLAGS) $(LIBFLAGS) $(CXXFLAGS) $(LDFLAGS)

$(ICODIR)/ico.res: $(ICODIR)/ico.rc
	windres -O coff -o $@ $^

create:
	IF EXIST ./bin rmdir bin /s /q
	IF EXIST ./obj rmdir obj /s /q
	mkdir $(OBJDIR) && exit 0
	mkdir bin && exit 0

test:
	bin/bongo.exe

clean:
	del $(OBJ) && exit 0
	del ico/ico.res && exit 0
