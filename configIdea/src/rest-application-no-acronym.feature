Feature: Microservice

  Background:
    Given rest-client: reqres
    Given set url: 'https://reqres.in/'
    Given set gemfire: demohost
    Given def testvar = 'testVar'
    Given def inputFile = read('C:\Automation\testFile.txt')


#####################################################################################
##### Sample Scenario using background declarations
#####################################################################################

  Scenario Outline: Migrate country scenario with framework
    ##### assign input files to a variable
    Given def activeCountry = read('<FullPathOfFile>') # read from file and store in activeCountry
      #  | effectiveDate | now | ###### shouldn't be needed as it should be part of file.
    And def expiredCountry = read('<FullPathOfFile>')
      #  | effectiveDate | now - 2 | ###### shouldn't be needed as it should be part of file.
      ##### set path (optional)
    And set path: '/api/users'
      ##### request keyword defines the data to POST
    And set request: {"country":"UK","code":"44","date":"TODAY"}
    or
    And set request: $activeCountry

      ###### post first file with effective date as todays date
    When execute POST ##### picks the last defined rest-client, path and input payload from request
    Then validate status 201

      ###### get the records for todays date
    Given set queryparam: [date=TODAY] ##### framework automatically prepends query param with "?" before appending it to path
    When execute GET ##### uses last defined rest-client, path and queryparam

      ##### Then validate the output
    Then validate status 200
        ###### match count of all records with effectiveDate as today
    Then validate response.country.count == $activeCountry.country.count
  or
    Then validate response.country.count == request.country.count ##### only if the request was made within the same When call

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
    And set headers:
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


