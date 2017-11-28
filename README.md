Cloud ML interface for R
================

[![Build Status](https://travis-ci.org/rstudio/cloudml.svg?branch=master)](https://travis-ci.org/rstudio/cloudml) [![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/cloudml)](https://cran.r-project.org/package=cloudml)

The **cloudml** package provides an R interface to [Google Cloud Machine Learning](https://cloud.google.com/ml-engine/). **cloudml** makes it easy to take machine learning applications built with R packages like [tensorflow](https://tensorflow.rstudio.com/), [Keras](https://keras.rstudio.com/), and [tfestimators](https://tensorflow.rstudio.com/tfestimators/), and use Google Cloud's machine learning platform for training, testing, and prediction.

Installation
------------

To get started, install the cloudml R package from GitHub as follows:

``` r
devtools::install_github("rstudio/cloudml")
```

Configuration
-------------

Before training in Google Cloud, one needs to configure: tools, projects, authentication and configuration files; which this section describes in detail.

### Tools

The **cloudml** package makes use of the [Google Cloud SDK](https://cloud.google.com/sdk/) for communication with Google Cloud Machine Learning. This SDK can be download and installed by following the instructions from [cloud.google.com/sdk/downloads](https://cloud.google.com/sdk/downloads).

### Projects

Before using the **cloudml** package, you'll need to make sure you're set up with an account and project on Google Cloud. Each **cloudml** application needs to be associated with a Google Cloud project and account. If you haven't already, you can [create an account](https://console.cloud.google.com) following the instructions online, and then [create a project](https://cloud.google.com/resource-manager/docs/creating-managing-projects) after that. You'll also want to provision a [bucket](https://cloud.google.com/storage/docs/creating-buckets), to be used as a storage space for applications trained in the cloud.

### Authentication

After creating your account, you'll need to set up default application credentials to ensure that the Google Cloud SDK can securely communicate with Google and take actions with your project. Try running

    gcloud auth application-default login

from a terminal, to request these credentials.

### Configuration Files

Application deployment is configured through the use of a top-level [YAML](http://yaml.org/) file called `cloudml.yml`. To create a default configuration file run:

``` r
library(cloudml)
cloudml_create_config()
```

Then modify this default file with the appropiate `project`, `account`, `region` and `sotage`:

``` yml
gcloud:
  project         : "project-name"
  account         : "account@domain.com"
  region          : "us-central1"
  runtime-version : "1.2"

cloudml:
  storage         : "gs://project-name/mnist"
```

The `gcloud` key is used for configuration specific to the Google Cloud SDK, and so contains items relevant to how applications are deployed.

-   Any deployments made will be associated with the `project` and `account` fields above,

-   Instances provisioned for training will be launched in the region specified by `region`,

-   The TensorFlow version to be used during training is configured using the `runtime-version` field.

The `storage` field in the `cloudml` section indicates where various artefacts used during provisioning and training are stored. Some useful paths to know:

-   `<storage>/staging`: applications will be 'staged' in this directory; that is, your deployed application will be uploaded and built in this location;

-   `<storage>/runs/<timestamp>`: training outputs will be copied to this directory.

Training
--------

We'll use the [MNIST example](https://github.com/rstudio/cloudml/tree/master/inst/examples/mnist/train.R) as we walk through the steps needed to get set up with Google Cloud. We use this application to build a model that classifies digits from the MNIST Dataset.

If you've followed these steps, your application should now be ready to be trainned in Google Cloud.

You can train your application with:

``` r
job <- cloudml_train()
```

This function will submit your application to Google Cloud, and request that it train your application by sourcing the training script `"train.R"`.

When using RStudio, a terminal window is used to stream the logs and download the job when it finializes.

When not using RStudio, you can ask the R session to wait for training to complete, and pull the generated models back to your local filesystem with:

``` r
job_collect(job)
```

The R session will wait and continue polling Google Cloud until your application has finished running; if the application trained successfully, then the trained models will be copied to disk under the `runs` directory.

Once the job is collected, you can use [tfruns](https://tensorflow.rstudio.com/tools/tfruns/) to view the results of the last run:

``` r
library(tfruns)
view_run()
```
