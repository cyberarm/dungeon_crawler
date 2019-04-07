class Wavefront
  class Parser
    attr_reader :faces
    def initialize(file_path)
      @file_path = file_path
      @file = File.read(file_path)
      @vertices = []
      @normals  = []
      @uvs      = []

      @faces = []
      @objects = []
      @materials = {}

      @current_material = nil
      @current_object = nil
      @smoothing = 0
      @vertex_count = 0

      parse
    end

    def parse
      lines = 0
      list = @file.split("\n")
      list.each do |line|
        lines+=1
        line = line.strip

        array = line.split(' ')
        case array[0]
        when 'mtllib'
          parse_mtllib(array[1])
        when 'usemtl'
          set_material(array[1])
        when 'o'
          change_object(array[1])
        when 's'
          set_smoothing(array[1])
        when 'v'
          add_vertex(array)
        when 'vt'
          add_texture_coordinate(array)

        when 'vn'
          add_normal(array)

        when 'f'
          verts = []
          uvs   = []
          norms = []
          array[1..3].each do |f|
            verts << f.split("/")[0]
            uvs   << f.split("/")[1]
            norms << f.split("/")[2]
          end

          _vertices = []
          _uvs      = []
          _normals  = []
          _texture = material.texture
          # _smoothing= @smoothing

          verts.each_with_index do |v, index|
            if uvs.first != ""
              _vertices << @vertices[Integer(v)-1]
              _uvs      << @uvs[Integer(uvs[index])-1]
              _normals  << @normals[Integer(norms[index])-1]
            else
              _vertices << @vertices[Integer(v)-1]
              _normals  << @normals[Integer(norms[index])-1]
            end
          end
          _colors = Array.new(_vertices.size, material.diffuse)

          face = Face.new(_vertices, _normals, _colors, _uvs, _texture)
          @current_object.faces << face
          @faces << face
        end
      end
    end

    def parse_mtllib(material_file)
      file = File.open(@file_path.sub(File.basename(@file_path), '')+material_file, 'r')
      file.readlines.each do |line|
        array = line.strip.split(' ')
        case array.first
        when 'newmtl'
          material = Material.new(array.last)
          @current_material = array.last
          @materials[array.last] = material
        when 'Ns' # Specular Exponent
        when 'Ka' # Ambient color
          @materials[@current_material].ambient  = GLColor.new(Float(array[1]), Float(array[2]), Float(array[3]))
        when 'Kd' # Diffuse color
          @materials[@current_material].diffuse  = GLColor.new(Float(array[1]), Float(array[2]), Float(array[3]))
        when 'Ks' # Specular color
          @materials[@current_material].specular = GLColor.new(Float(array[1]), Float(array[2]), Float(array[3]))
        when 'Ke' # Emissive
        when 'Ni' # Unknown (Blender Specific?)
        when 'd'  # Dissolved (Transparency)
        when 'illum' # Illumination model
        when 'map_Kd' # Diffuse texture
          @materials[@current_material].set_texture(array[1])
        end
      end
    end

    def change_object(name)
      @objects << ModelObject.new(name)
      @current_object = @objects.last
    end

    def set_smoothing(value)
      if value == "1"
        @smoothing = true
      else
        @smoothing = false
      end
    end

    def set_material(name)
      @current_material = name
    end

    def material
      @materials[@current_material]
    end

    def faces_count
      count = 0
      @objects.each {|o| count+=o.faces.count}
      return count
    end

    def add_vertex(array)
      @vertex_count+=1
      vert = nil
      if array.size == 5
        vert = Vector.new(Float(array[1]), Float(array[2]), Float(array[3]), Float(array[4]))
      elsif array.size == 4
        vert = Vector.new(Float(array[1]), Float(array[2]), Float(array[3]), 1.0)
      else
        raise
      end
      @vertices << vert
    end

    def add_normal(array)
      vert = nil
      if array.size == 5
        vert = Vector.new(Float(array[1]), Float(array[2]), Float(array[3]), Float(array[4]))
      elsif array.size == 4
        vert = Vector.new(Float(array[1]), Float(array[2]), Float(array[3]), 1.0)
      else
        raise
      end
      @normals << vert
    end

    def add_texture_coordinate(array)
      texture = nil
      if array.size == 4
        texture = Vector.new(Float(array[1]), 1-Float(array[2]), Float(array[3]))
      elsif array.size == 3
        texture = Vector.new(Float(array[1]), 1-Float(array[2]), 1.0)
      else
        raise
      end
      @uvs << texture
    end
  end
end