Dir.chdir(File.dirname(__FILE__))

case OpenGL.get_platform
when :OPENGL_PLATFORM_WINDOWS
  OpenGL.load_lib("opengl32.dll", "C:/Windows/System32")
  GLU.load_lib("GLU32.dll", "C:/Windows/System32")
when :OPENGL_PLATFORM_MACOSX
  OpenGL.load_lib("libGL.dylib", "/System/Library/Frameworks/OpenGL.framework/Libraries")
  GLU.load_lib("libGLU.dylib", "/System/Library/Frameworks/OpenGL.framework/Libraries")
when :OPENGL_PLATFORM_LINUX
  gl_library_path = nil

  if File.exists?("/usr/lib/x86_64-linux-gnu/libGL.so") # Ubuntu (Debian)
    gl_library_path = "/usr/lib/x86_64-linux-gnu"

  elsif File.exists?("/usr/lib/libGL.so") # Manjaro (ARCH)
    gl_library_path = "/usr/lib"

  elsif File.exists?("/usr/lib/arm-linux-gnueabihf/libGL.so") # Raspbian (ARM/Raspberry Pi)
    gl_library_path = "/usr/lib/arm-linux-gnueabihf"
  end

  if gl_library_path
    OpenGL.load_lib("libGL.so", gl_library_path)
    GLU.load_lib("libGLU.so", gl_library_path)
  else
    raise RuntimeError, "Couldn't find GL libraries"
  end
else
  raise RuntimeError, "Unsupported platform."
end

GLColor = Struct.new(:red, :green, :blue, :alpha)