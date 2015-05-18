require 'digest'

module PgSearch
  class Configuration
    class Column
      attr_reader :weight, :name

      def initialize(column, weight, model)
        column = PlainColumn.new(column) unless column.is_a?(PlainColumn)
        @column = column
        @name = @column.name
        @model = model
        @weight = weight
      end

      def full_name
        @column.full_name(connection, *full_name_options)
      end

      def to_sql
        coalesce("#{expression}::text")
      end

      def to_sql_no_cast
        coalesce(expression)
      end

      def tsvector?
        psql_column = @model.columns_hash[name]
        psql_column && psql_column.type.eql?(:tsvector)
      end

      private

      def expression
        @column.to_sql(connection, *to_sql_options)
      end

      def connection
        @model.connection
      end

      def to_sql_options
        [@model.table_name]
      end

      def full_name_options
        [@model.table_name]
      end

      def coalesce(value)
        "coalesce(#{value}, '')"
      end
    end
  end
end
