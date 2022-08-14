defmodule Codebattle.Languages do
  @moduledoc false

  alias Codebattle.Language
  alias Codebattle.Generators.SolutionTemplateGenerator

  @type_templates %{
    boolean_true: "true",
    boolean_false: "false",
    array: "[<%= entries %>]",
    hash_empty: "{}",
    hash_value: "{<%= entries %>}",
    hash_inners: "\"<%= key %>\": <%= value %>"
  }

  @meta %{
    "ruby" => %Language{
      name: "ruby",
      slug: "ruby",
      checker_version: 2,
      version: "3.1.2",
      check_dir: "check",
      extension: "rb",
      docker_image: "codebattle/ruby:3.1.2",
      solution_version: :default,
      solution_template: "def solution(<%= arguments %>)\n<%= return_statement %>\nend",
      arguments_template: %{
        argument: "<%= name %>",
        delimiter: ", "
      },
      return_template: "\t<%= default_value %>",
      default_values: %{
        "integer" => "0",
        "float" => "0.1",
        "string" => "\"value\"",
        "array" => "[<%= value %>]",
        "boolean" => "false",
        "hash" => "{\"key\" => <%= value %>}"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: %{@type_templates | hash_inners: "\"<%= key %>\" => <%= value %>"}
      }
    },
    "js" => %Language{
      checker_version: 2,
      name: "Node.js",
      slug: "js",
      version: "17.5",
      check_dir: "check",
      extension: "js",
      docker_image: "codebattle/js:17.5",
      solution_version: :default,
      solution_template:
        "const _ = require(\"lodash\");\nconst R = require(\"rambda\");\n\nconst solution = (<%= arguments %>) => {\n<%= return_statement %>\n};\n\nmodule.exports = solution;",
      arguments_template: %{
        argument: "<%= name %>",
        delimiter: ", "
      },
      return_template: "\treturn <%= default_value %>;",
      default_values: %{
        "integer" => "0",
        "float" => "0.1",
        "string" => "\"value\"",
        "array" => "[<%= value %>]",
        "boolean" => "true",
        "hash" => "{\"key\": <%= value %>}"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: @type_templates
      }
    },
    "ts" => %Language{
      checker_version: 2,
      name: "typescript",
      slug: "ts",
      version: "4.1.3",
      check_dir: "check",
      extension: "js",
      docker_image: "codebattle/js:15.5.1",
      solution_version: :typed,
      solution_template:
        "<%= import %>function solution(<%= arguments %>)<%= expected %>{\n\n};\n\nexport default solution;",
      arguments_template: %{
        argument: "<%= name %>: <%= type %>",
        delimiter: ", "
      },
      expected_template: ": <%= type %> ",
      types: %{
        "integer" => "number",
        "float" => "number",
        "string" => "string",
        "array" => "Array<<%= inner_type %>>",
        "boolean" => "boolean",
        "hash" => "any"
      },
      checker_meta: %{
        version: :static,
        type_templates: @type_templates,
        defining_variable_template: "<%= name %>: <%= type %>",
        nested_value_expression_template: "<%= value %>"
      }
    },
    "dart" => %Language{
      name: "Dart",
      slug: "dart",
      version: "2.17.6",
      check_dir: "lib",
      extension: "dart",
      docker_image: "codebattle/dart:2.17.6",
      solution_version: :typed,
      solution_template: "<%= expected %>solution(<%= arguments %>) {\n\n}",
      arguments_template: %{
        argument: "<%= type %> <%= name %>",
        delimiter: ", "
      },
      expected_template: "<%= type %> ",
      types: %{
        "integer" => "int",
        "float" => "double",
        "string" => "String",
        "array" => "List<<%= inner_type %>>",
        "boolean" => "bool",
        "hash" => "Map<String, <%= inner_type %>>"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: @type_templates
      }
    },
    "cpp" => %Language{
      name: "C++",
      slug: "cpp",
      version: "20",
      check_dir: "check",
      extension: "cpp",
      docker_image: "codebattle/cpp:20",
      solution_version: :typed,
      solution_template:
        "#include <iostream>\n#include <map>\n#include <vector>\n\nusing namespace std;\n\n<%= expected %> solution(<%= arguments %>) {\n\n}",
      arguments_template: %{
        argument: "<%= type %> <%= name %>",
        delimiter: ", "
      },
      expected_template: "<%= type %>",
      types: %{
        "integer" => "int",
        "float" => "double",
        "string" => "string",
        "array" => "vector<<%= inner_type %>>",
        "boolean" => "bool",
        "hash" => "map<string,<%= inner_type %>>"
      },
      checker_meta: %{
        version: :static,
        type_templates: %{
          @type_templates
          | array: "{<%= entries %>}",
            hash_inners: "{\"<%= key %>\", <%= value %>}"
        },
        defining_variable_template: "<%= type %> <%= name %>",
        nested_value_expression_template: "<%= type_name %><%= value %>"
      }
    },
    "java" => %Language{
      name: "Java",
      slug: "java",
      version: "18",
      check_dir: "check",
      extension: "java",
      docker_image: "codebattle/java:18",
      solution_version: :typed,
      solution_template:
        "package solution;\n\nimport java.util.*;import java.util.stream.*;\n\npublic class Solution {\n\tpublic <%= expected %>solution(<%= arguments %>) {\n\n\t}\n}",
      arguments_template: %{
        argument: "<%= type %> <%= name %>",
        delimiter: ", "
      },
      expected_template: "<%= type %> ",
      types: %{
        "integer" => "Integer",
        "float" => "Double",
        "string" => "String",
        "array" => "List<<%= inner_type %>>",
        "boolean" => "Boolean",
        "hash" => "Map<String, <%= inner_type %>>"
      },
      checker_meta: %{
        version: :static,
        type_templates: %{
          @type_templates
          | array: "List.of(<%= entries %>)",
            hash_empty: "Map.of()",
            hash_value: "Map.ofEntries(<%= entries %>)",
            hash_inners: "entry(\"<%= key %>\", <%= value %>)"
        },
        defining_variable_template: "<%= type %> <%= name %>",
        nested_value_expression_template: "<%= value %>"
      }
    },
    "kotlin" => %Language{
      name: "Kotlin",
      slug: "kotlin",
      version: "1.6.21",
      check_dir: "check",
      extension: "kt",
      docker_image: "codebattle/kotlin:1.6.21",
      solution_version: :typed,
      solution_template:
        "package solution\n\nimport kotlin.collections.*\n\nfun solution(<%= arguments %>):<%= expected %> {\n\n}",
      arguments_template: %{
        argument: "<%= name %>: <%= type %>",
        delimiter: ", "
      },
      expected_template: " <%= type %>",
      types: %{
        "integer" => "Int",
        "float" => "Double",
        "string" => "String",
        "array" => "List<<%= inner_type %>>",
        "boolean" => "Boolean",
        "hash" => "Map<String, <%= inner_type %>>"
      },
      checker_meta: %{
        version: :static,
        type_templates: %{
          @type_templates
          | array: "listOf(<%= entries %>)",
            hash_empty: "mapOf()",
            hash_value: "mapOf(<%= entries %>)",
            hash_inners: "\"<%= key %>\" to <%= value %>"
        },
        defining_variable_template: "<%= name %>: <%= type %>",
        nested_value_expression_template: "<%= value %>"
      }
    },
    "csharp" => %Language{
      name: "C#",
      slug: "csharp",
      version: "6.0.100",
      check_dir: "check",
      extension: "cs",
      docker_image: "codebattle/csharp:6.0.100",
      solution_version: :typed,
      solution_template:
        "using System;using System.Collections.Generic;\n\nnamespace app\n{\n\tpublic class Solution\n\t{\n\t\tpublic<%= expected %> solution(<%= arguments %>)\n\t\t{\n\n\t\t}\n\t}\n}",
      arguments_template: %{
        argument: "<%= type %> <%= name %>",
        delimiter: ", "
      },
      expected_template: " <%= type %>",
      types: %{
        "integer" => "int",
        "float" => "double",
        "string" => "string",
        "array" => "List<<%= inner_type %>>",
        "boolean" => "bool",
        "hash" => "Dictionary<string, <%= inner_type %>>"
      },
      checker_meta: %{
        version: :static,
        type_templates: %{
          @type_templates
          | array: "{<%= entries %>}",
            hash_empty: "{}",
            hash_value: "{<%= entries %>}",
            hash_inners: "{\"<%= key %>\", <%= value %>}"
        },
        defining_variable_template: "<%= type %> <%= name %>",
        nested_value_expression_template: "new <%= type_name %>()<%= value %>"
      }
    },
    "golang" => %Language{
      name: "golang",
      slug: "golang",
      version: "1.19.0",
      check_dir: "check",
      extension: "go",
      docker_image: "codebattle/golang:1.19.0",
      solution_version: :typed,
      solution_template: "package main;\n\nfunc solution(<%= arguments %>)<%= expected %> {\n\n}",
      arguments_template: %{
        argument: "<%= name %> <%= type %>",
        delimiter: ", "
      },
      expected_template: " <%= type %>",
      types: %{
        "integer" => "int64",
        "float" => "float64",
        "string" => "string",
        "array" => "[]<%= inner_type %>",
        "boolean" => "bool",
        "hash" => "map[string]<%= inner_type %>"
      },
      checker_meta: %{
        version: :static,
        type_templates: %{@type_templates | array: "{<%= entries %>}"},
        defining_variable_template: "<%= name %> <%= type %>",
        nested_value_expression_template: "<%= type_name %><%= value %>"
      }
    },
    "elixir" => %Language{
      name: "elixir",
      slug: "elixir",
      version: "1.13.4",
      check_dir: "check",
      extension: "exs",
      docker_image: "codebattle/elixir:1.13.4",
      solution_version: :default,
      solution_template:
        "defmodule Solution do\n\tdef solution(<%= arguments %>) do\n<%= return_statement %>\n\tend\nend",
      arguments_template: %{
        argument: "<%= name %>",
        delimiter: ", "
      },
      return_template: "\t\t<%= default_value %>",
      default_values: %{
        "integer" => "0",
        "float" => "0.1",
        "string" => "\"value\"",
        "array" => "[<%= value %>]",
        "boolean" => "false",
        "hash" => "%{\"key\": <%= value %>}"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: %{@type_templates | hash_empty: "%{}", hash_value: "%{<%= entries %>}"}
      }
    },
    "python" => %Language{
      name: "python",
      slug: "python",
      version: "3.10.6",
      check_dir: "check",
      extension: "py",
      docker_image: "codebattle/python:3.10.6",
      solution_version: :typed,
      solution_template:
        "from typing import List, Dict\n\ndef solution(<%= arguments %>)<%= expected %>:",
      arguments_template: %{
        argument: "<%= name %>: <%= type %>",
        delimiter: ", "
      },
      expected_template: " -> <%= type %>",
      types: %{
        "integer" => "int",
        "float" => "float",
        "string" => "str",
        "array" => "List[<%= inner_type %>]",
        "boolean" => "bool",
        "hash" => "Dict[str, <%= inner_type %>]"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: %{@type_templates | boolean_true: "True", boolean_false: "False"}
      }
    },
    "php" => %Language{
      name: "php",
      slug: "php",
      version: "8.1.8",
      check_dir: "check",
      extension: "php",
      docker_image: "codebattle/php:8.1.8",
      solution_version: :typed,
      solution_template:
        "<?php\n\nfunction solution(<%= arguments %>)\n{<%= return_statement %>\n}",
      return_template: "\n    return <%= default_value %>;",
      arguments_template: %{
        argument: "<%= type %> $<%= name %>",
        delimiter: ", "
      },
      default_values: %{
        "integer" => "0",
        "float" => "0.1",
        "string" => "\"value\"",
        "array" => "[<%= value %>]",
        "boolean" => "false",
        "hash" => "array(\"key\" => <%= value %>)"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: %{
          @type_templates
          | array: "array(<%= entries %>)",
            hash_empty: "array()",
            hash_value: "array(<%= entries %>)",
            hash_inners: "\"<%= key %>\" => <%= value %>"
        }
      },
      types: %{
        "integer" => "int",
        "float" => "float",
        "string" => "string",
        "array" => "array",
        "boolean" => "bool",
        "hash" => "array"
      }
    },
    "clojure" => %Language{
      name: "clojure",
      slug: "clojure",
      version: "1.11.1",
      check_dir: "check",
      extension: "clj",
      docker_image: "codebattle/clojure:1.11.1.1105",
      solution_version: :default,
      solution_template: "(defn solution [<%= arguments %>] <%= return_statement %>)",
      arguments_template: %{
        argument: "<%= name %>",
        delimiter: " "
      },
      return_template: "<%= default_value %>",
      default_values: %{
        "integer" => "0",
        "float" => "0.1",
        "string" => "\"value\"",
        "array" => "[<%= value %>]",
        "boolean" => "false",
        "hash" => "{:key <%= value %>}"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: ", ",
        type_templates: %{@type_templates | hash_inners: ":<%= key %> <%= value %>"}
      }
    },
    "haskell" => %Language{
      name: "haskell",
      slug: "haskell",
      version: "8.4.3",
      extension: "hs",
      check_dir: "Check",
      docker_image: "codebattle/haskell:8.4.3",
      solution_version: :typed,
      solution_template:
        "module Check.Solution where\n\nimport qualified Data.HashMap.Lazy as HM\n\nsolution :: <%= arguments %><%= expected %>\nsolution =\n\n{- Included packages:\naeson\nbytestring\ncase-insensitive\ncontainers\ndeepseq\nfgl\ninteger-logarithms\nmegaparsec\nmtl\nparser-combinators\npretty\nrandom\nregex-base\nregex-compat\nregex-posix\nscientific\nsplit\ntemplate-haskell\ntext\ntime\ntransformers\nunordered-containers\nvector\nvector-algorithms -}",
      arguments_template: %{
        argument: "<%= type %>",
        delimiter: " -> "
      },
      expected_template: " -> <%= type %>",
      types: %{
        "integer" => "Int",
        "float" => "Double",
        "string" => "String",
        "array" => "[<%= inner_type %>]",
        "boolean" => "Bool",
        "hash" => "HM.HashMap String <%= inner_type %>"
      },
      checker_meta: %{
        version: :dynamic,
        arguments_delimiter: " ",
        type_templates: %{
          @type_templates
          | boolean_true: "True",
            boolean_false: "False",
            hash_empty: "empty"
        }
      }
    }
  }

  def get_solution(lang, task) do
    @meta
    |> Map.get(lang)
    |> SolutionTemplateGenerator.get_solution(task)
  end

  def get_langs, do: Map.keys(@meta)

  def get_langs_with_solutions(task) do
    @meta
    |> Map.values()
    |> Enum.map(fn el ->
      Map.put(
        el,
        :solution_template,
        el
        |> SolutionTemplateGenerator.get_solution(task)
      )
    end)
  end

  def meta, do: @meta
end
