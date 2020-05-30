Feature: Microservice

  Background:
    Given rest-client $api-gateway-1


  Scenario: Happy path: Able to fetch employee details successfully by unique identifier
    Given a unique input identifier "abc-bed-123-455"
    And add headers for "employee-service"
      | Cache-Control | Never |
    When  "fetch_employee" is called
    Then  "api-gateway" should return "200" as status

  Scenario: Happy path: Able to fetch offshore employee details successfully by unique identifier
    Given a unique input identifier "abc-bed-123-455"
    And add headers for "simple_service"
      | Cache-Control | Never |
    When  "offshore-service-employee" "fetch_employee" is called
    Then  "employee-service" returns "200" as status


    Given new countries including an expired country is posted
    When get all country service is called with current effective date
    Then atleast 1 country record is retrieved successfully
    And the new posted country record is retrieved
    And an expired country record is not retrieved

#####################################################################################
##### Sample Scenario with both tech definitions and using business friendly acronyms
#####################################################################################

    Scenario Outline: Migrate country scenario with framework
    ##### assign input files to a variable
      Given def activeCountry = read('<FullPathOfFile>') # read from file and store in activeCountry
      #  | effectiveDate | now | ###### shouldn't be needed as it should be part of file.
      And def expiredCountry = read('<FullPathOfFile>')
      #  | effectiveDate | now - 2 | ###### shouldn't be needed as it should be part of file.
      ##### set path (optional)
      And set path "<path>"
      ##### request keyword defines the data to POST
      And request $activeCountry
      ###### post first file with effective date as todays date
      When execute POST ##### picks the last defined request by default and the set path
      or

      When execute create_countries  ##### picks the path defined in yml file
      Then validate record_created_successfully

      ###### get the records for todays date
      When execute GET # pass queryparam on the operation command
          ##### define and set query param
      And set queryParam effectiveDate = NOW ##### queryparam is a keyword which defines the query string to be used in path

      or
      When execute get_all_countries  ##### pass queryparam on the operation command
      And set queryParam effectiveDate = NOW ##### queryparam is a keyword which defines the query string to be used in path

      ##### Then validate the output
      Then validate status 200
      or
      Then validate records_successfully_retrieved

      ###### match count of all records with effectiveDate as today
      Then validate response.$country.count = $activeCountry.$country.count # rowcount
      or
      Then validate response.$country.count = request.$country.count

      ###### clear set queryParam
      Then clear queryParam
      ###### post second file withe effective date in pat

      When execute POST
      And set path "<path>"
      or
      When create_countries

      And request $expiredCountry # pass the second file in POST
      Then validate record_created_successfully

      ###### get the records for yesterdays date
      When execute "get_all_countries"
      And set queryparam effectiveDate = t-2

      ###################
      And set headers
        | accept | application/json |
      ###################

      Then validate status 200
      or
      Then validate records_successfully_retrieved

      ###### match count of all records with effectiveDate of t-2
      Then validate response.$country.count = $expiredCountry.$country.count # rowcount

      ######## validate "id" value exactly matches a defined output
      Then validate response.$country.$id = "abc-bed-123-455"
      #############################################

      When execute get_country_by_id <id>
      Then validate response.$country.count > 1

      Examples:
      |id|
      |1|


#####################################################################################
##### Sample Scenario using technical signature
#####################################################################################

  Scenario Outline: Migrate country scenario with framework
    ##### assign input files to a variable
    Given def activeCountry = read('<FullPathOfFile>') # read from file and store in activeCountry
      #  | effectiveDate | now | ###### shouldn't be needed as it should be part of file.
    And def expiredCountry = read('<FullPathOfFile>')
      #  | effectiveDate | now - 2 | ###### shouldn't be needed as it should be part of file.
      ##### set path (optional)
    And set path "<path>"
      ##### request keyword defines the data to POST
    And request $activeCountry

      ###### post first file with effective date as todays date
    When execute POST ##### picks the last defined request by default and the set path

      ###### get the records for todays date
    When execute GET # pass queryparam on the operation command

      ##### define and set query param
    And set queryParam: effectiveDate = NOW ##### queryparam is a keyword which defines the query string to be used in path

      ##### Then validate the output
    Then validate status 200
        ###### match count of all records with effectiveDate as today
    Then validate response.$country.count = $activeCountry.$country.count # rowcount
  or
    Then validate response.$country.count = request.$country.count

      ###### clear set queryParam
    Then clear queryParam
      ###### post second file withe effective date in pat

    When execute POST
    And set path "<path>"
  or
    When create_countries

    And request $expiredCountry # pass the second file in POST
    Then validate record_created_successfully

      ###### get the records for yesterdays date
    When execute "get_all_countries"
    And set queryparam effectiveDate = t-2

      ###################
    And set headers
      | accept | application/json |
      ###################

    Then validate status 200
  or
    Then validate records_successfully_retrieved

      ###### match count of all records with effectiveDate of t-2
    Then validate response.$country.count = $expiredCountry.$country.count # rowcount

      ######## validate "id" value exactly matches a defined output
    Then validate response.$country.$id = "abc-bed-123-455"
      #############################################

    When execute get_country_by_id <id>
    Then validate response.$country.count > 1

    Examples:
      |id|
      |1|
