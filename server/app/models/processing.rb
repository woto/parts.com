class Processing
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Translation
  extend ActiveModel::Callbacks
    
  attr_accessor :fields, :datetime, :processes
    
  validates :fields, :presence => true, :numericality => {:only_integer => true}
  validates :processes, :presence => true, :numericality => {:only_integer => true}
  
  define_model_callbacks :save
  
  def initialize(attributes={})
    attributes.stringify_keys!
    multi_parameter_attributes = []

    attributes.each do |k, v|
      # extracted from active_record/base.rb
      if k.include?("(")
        multi_parameter_attributes << [ k, v ]
      elsif respond_to?("#{k}=")
        send("#{k}=", v)
      else
        raise(UnknownAttributeError, "unknown attribute: #{k}")
      end
    end

    # extracted from active_record/base.rb
    assign_multiparameter_attributes(multi_parameter_attributes)
  end

  # extracted from active_record/base.rb
  def assign_multiparameter_attributes(pairs)
    execute_callstack_for_multiparameter_attributes(
      extract_callstack_for_multiparameter_attributes(pairs)
    )
  end

  def extract_callstack_for_multiparameter_attributes(pairs)
    attributes = { }

    pairs.each do |pair|
      multiparameter_name, value = pair 
      attribute_name = multiparameter_name.split("(").first
      attributes[attribute_name] = {} unless attributes.include?(attribute_name)

      parameter_value = value.empty? ? nil : type_cast_attribute_value(multiparameter_name, value)
      attributes[attribute_name][find_parameter_position(multiparameter_name)] ||= parameter_value
    end  

    attributes
  end 

      def execute_callstack_for_multiparameter_attributes(callstack)
        errors = []
        callstack.each do |name, values_with_empty_parameters|
          begin
            debugger
            send(name + "=", read_value_from_parameter(name, values_with_empty_parameters))
          rescue => ex
            errors << AttributeAssignmentError.new("error on assignment #{values_with_empty_parameters.values.inspect} to #{name}", ex, name)
          end
        end
        unless errors.empty?
          raise MultiparameterAssignmentErrors.new(errors), "#{errors.size} error(s) on assignment of multiparameter attributes"
        end
      end

      def read_value_from_parameter(name, values_hash_from_param)
        debugger
	#klass = (self.class.reflect_on_aggregation(name.to_sym) || column_for_attribute(name)).klass
        if name == 'datetime'
          klass = Time
        else
          raise 'Необходимо создать тип'
        end

        if values_hash_from_param.values.all?{|v|v.nil?}
          nil
        elsif klass == Time
          read_time_parameter_value(name, values_hash_from_param)
        elsif klass == Date
          read_date_parameter_value(name, values_hash_from_param)
        else
          read_other_parameter_value(klass, name, values_hash_from_param)
        end
      end

      def read_time_parameter_value(name, values_hash_from_param)
        # If Date bits were not provided, error
        raise "Missing Parameter" if [1,2,3].any?{|position| !values_hash_from_param.has_key?(position)}
        max_position = extract_max_param_for_multiparameter_attributes(values_hash_from_param, 6)
        set_values = (1..max_position).collect{|position| values_hash_from_param[position] }
        # If Date bits were provided but blank, then default to 1
        # If Time bits are not there, then default to 0
        [1,1,1,0,0,0].each_with_index{|v,i| set_values[i] = set_values[i].blank? ? v : set_values[i]}
        instantiate_time_object(name, set_values)
      end

      def instantiate_time_object(name, values)
        Time.zone.local(*values)
      end

      def type_cast_attribute_value(multiparameter_name, value)
        multiparameter_name =~ /\([0-9]*([if])\)/ ? value.send("to_" + $1) : value
      end

      def find_parameter_position(multiparameter_name)
        multiparameter_name.scan(/\(([0-9]*).*\)/).first.first.to_i
      end

      def extract_max_param_for_multiparameter_attributes(values_hash_from_param, upper_cap = 100)
        [values_hash_from_param.keys.max,upper_cap].min
      end
  
  def read_attribute_for_validation(key)
    send(key)
  end

  def persisted?
    false
  end
  
  def save
    if valid?
      keys = {}
      Part.joins(:manufacturer).all.each_with_index do |part, i|
       keys["partNumber#{i}"] = part.catalog_number
       keys["makeid#{i}"] = part.manufacturer.parts_com_id
      end
      agent = Mechanize.new
      result = agent.post('http://www.parts.com/oemcatalog/index.cfm?action=getMultiSearchItems&siteid=2&items=30', keys)
      return result.search("table[1] table table")
    else
      return false
    end
  end
end
