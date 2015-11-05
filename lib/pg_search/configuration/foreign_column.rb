require 'digest'

module PgSearch
  class Configuration
    class ForeignColumn < Column
      def initialize(column, weight, association)
        super(column, weight, association.reflection.klass)
        @table_alias = association.subselect_alias
      end

      def alias
        Configuration.alias(table_alias, @column.name)
      end

      private

      attr_reader :table_alias

      def to_sql_options
        [table_alias, self.alias]
      end
    end
  end
end
