# frozen_string_literal: true

RgGen.define_list_feature(:register, :type) do
  verilog do
    base_feature do
      include RgGen::SystemVerilog::RTL::RegisterType
    end

    default_feature do
      main_code :register, from_template: File.join(__dir__, 'type', 'default.erb')
    end

    factory do
      def target_feature_key(_configuration, register)
        type = register.type
        valid_type?(type) && type ||
          (error "code generator for #{type} register type is not implemented")
      end

      private

      def valid_type?(type)
        target_features.key?(type) || type == :default
      end
    end
  end
end
