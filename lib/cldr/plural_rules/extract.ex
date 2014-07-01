defmodule Cldr.PluralRules.Extract do
  @moduledoc """
  Extract all the plural rules for many locales from the CLDR file that defines them.
  """

  @doc """
  Extract all the plural rules for many locales from the CLDR file that defines them.
  """
  def from(file) do
    {xml, _} = :xmerl_scan.file(file)

    allRules = find('/supplementalData/plurals/pluralRules', xml)
    Enum.map allRules, &extract_rules/1
  end

  @doc """
  Alias for `:xmerl_xpath.string`.
  The `xpath` argument needs to be a char list.
  """
  defp find(xpath, document) do
    :xmerl_xpath.string(xpath, document)
  end

  @doc """
  Extract the plural rules for a given set of locales.

  # Return value

  This function returns a list. Each element of the list is a tuple where the first element is the list of the locales and where the second argument is a list of the plural rules (see the extract_rule/1 function for the structure of it).

  # Implementation

  This is an example of the XML element from which we should extract the rules:

  ```xml
  <pluralRules locales="am bn fa gu hi kn mr zu">
    <pluralRule count="one">i = 0 or n = 1 @integer 0, 1 @decimal 0.0~1.0, 0.00~0.04</pluralRule>
    <pluralRule count="other"> @integer 2~17, 100, 1000, 10000, 100000, 1000000, … @decimal 1.1~2.6, 10.0, 100.0, 1000.0, 10000.0, 100000.0, 1000000.0, …</pluralRule>
  </pluralRules>
  ```
  
  The `locales` attribute of the `pluralRules` element is converted to a list of strings, like this: `["am", "bn", "fa", "gu", "hi", "kn", "mr", "zu"]`.

  Then, each plural rule is parsed (see the extract_rule/1 function for implementation details).
  """
  defp extract_rules(rules) do
    locales = find('string(/pluralRules/@locales)', rules)
      |> elem(2)
      |> to_string
      |> String.split

    individual_rules = find('/pluralRules/pluralRule', rules)
    individual_rules_extracted = Enum.map individual_rules, &extract_rule/1

    {locales, individual_rules_extracted}
  end

  @doc """
  Extract a plural rule.

  # Return value

  This function returns a tuple. The first element is the mnemonic tag for the plural category and the second one is the string representation of the rule associated without the samples provided by CLDR.

  # Implementation

  This is an example of the XML element from which we should extract the plural rule:

  ```xml
  <pluralRule count="one">i = 0 or n = 1 @integer 0, 1 @decimal 0.0~1.0, 0.00~0.04</pluralRule>
  ```
  
  This function would return {:one, "i = 0 or n = 1"} with this XML element.
  """
  defp extract_rule(rule) do
    tag  = find('string(/pluralRule/@count)', rule)
      |> elem(2)
      |> List.to_atom

    rule = find('string(/pluralRule[text()])', rule)
      |> elem(2)
      |> to_string
    # Remove the samples from the rule
      |> String.split("@", parts: 2)
      |> List.first
      |> String.rstrip

    {tag, rule}
  end
end