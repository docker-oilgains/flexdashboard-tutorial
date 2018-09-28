# latest R (3.5.1), latest RStudio (1.1.456) as of 20180910
FROM rocker/rstudio-stable:latest
LABEL maintainer = "Alfonso Reyes <alfonso.reyes@oilgainsanalytics.com"

# Make ~/.R  
RUN mkdir -p $HOME/.R

# $HOME doesn't exist in the COPY shell, so be explicit  
COPY R/Makevars /root/.R/Makevars

RUN apt-get update -qq \ 
    && apt-get -y --no-install-recommends install \ 
    liblzma-dev \ 
    libbz2-dev \ 
    libxml2-dev \
    libssl-dev \
    libgit2-dev \
    zlib1g-dev \
    clang  \ 
    ccache \ 
    default-jdk \ 
    default-jre \ 
    && R CMD javareconf

RUN  apt-get -y --no-install-recommends install \ 
    libmagick++-dev

RUN install2.r --error \ 
        ggstance ggrepel ggthemes \ 
        ###My packages are below this line 
        tidytext janitor corrr officer devtools pacman \ 
        tidyquant timetk tibbletime sweep broom prophet \ 
        forecast prophet lime sparklyr h2o rsparkling unbalanced \ 
        formattable httr rvest xml2 jsonlite \ 
        textclean naniar writexl \ 
    && Rscript -e 'devtools::install_github(c("hadley/multidplyr","jeremystan/tidyjson","ropenscilabs/skimr"))' \ 
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \ 
    && rm -rf /var/lib/apt/lists/*