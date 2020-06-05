Feature: Portfolio & Positions

  Background:
    Given rest-client: @portfolioOptimiser
    Given def portfolioName = 'myPortfolio'
    Given def portfolioDetails = read('portfolioDetails')

#####################################################################################
##### Sample scenarios to create portfolio and inject portfolio records
#####################################################################################

      ##### create portfolioName
  Scenario: Create a portfolio named myPortfolio
    Given set payload: name = $portfolioName
    When execute create_portfolio
    Then validate portfolio_created_successfully

    ##### Inject positions in portfolio
   Scenario: Inject positions in the created portfolio
     Given set payload: read('portfolioDetails')
     And set queryparam: 'portfolio=myportfolio'  ##### Find a way of passing variable in queryparam. eg: queryparam: 'portfolio='$portfolioName
     When execute set_portfolio_positions
     Then validate portfolio_created_successfully

    ##### Validate portfolio count
   Scenario: get details of portoflio
     Given set queryparam: 'portfolio=myportfolio'
     When execute get_portfolio
     Then validate portfolio_details_successfully_retrieved
     Then validate response.count  == $portfolioDetails.count






