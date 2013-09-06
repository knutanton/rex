# features/search_result.feature

Feature: Search Result
  In order get the relevant information from Primo
  As a user of REX
  I want to see a slightly changed resultset
  So that I can navigate properly


  Scenario: FRBR records from PCI
    Given I am on the frontpage of REX in the article tab
    And search for the term 'linux'
    Then there should be no occurences of both "Se alle versioner" and "Detaljer" any records

   