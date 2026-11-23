/*
Project: Student Performance Logistic Regression
Group J academic project
Response variable: RESULT
*/

/* 1. Test association between categorical variables and result */

proc freq data=education;
    tables gender*result / chisq;
    tables placeofbirth*result / chisq;
    tables stageid*result / chisq;
    tables relation*result / chisq;
    tables studentabsencedays*result / chisq;
run;

/* 2. Full logistic regression model */

proc logistic data=education;
    class gender placeofbirth stageid relation
          studentabsencedays / param=reference;

    model result(event='Passed') =
          gender placeofbirth stageid relation
          studentabsencedays grade raisedhands
          visitedresources announcementsview discussion;
run;

/* 3. Reduced logistic regression model */

proc logistic data=education;
    class stageid relation studentabsencedays / param=reference;

    model result(event='Passed') =
          stageid relation studentabsencedays
          grade visitedresources announcementsview
          / lackfit;

    store out=estimates;
run;

/* 4. Final model and goodness-of-fit assessment */

proc logistic data=education plots=all;
    class stageid relation studentabsencedays / param=reference;

    model result(event='Passed') =
          stageid relation studentabsencedays
          grade visitedresources announcementsview
          / aggregate=(gender placeofbirth stageid
                       relation studentabsencedays)
            scale=none lackfit;
run;

/* 5. Additional model assessment */

proc genmod data=education;
    class stageid relation studentabsencedays / param=reference;

    model result(event='Passed') =
          stageid relation studentabsencedays
          grade visitedresources announcementsview
          / aggregate=(gender placeofbirth stageid
                       relation studentabsencedays)
            scale=pearson dist=binomial link=logit;
run;

/* 6. Predict probabilities for first three observations */

proc plm source=estimates;
    score data=education(obs=3) out=predictions;
run;

proc print data=predictions;
    title 'Predicted Probabilities for First 3 Observations';
run;
