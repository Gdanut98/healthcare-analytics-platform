-- Replace `portfolio_healthcare` with your GCP project ID before execution.
CREATE SCHEMA IF NOT EXISTS `portfolio_healthcare.raw` OPTIONS(location='US');
CREATE SCHEMA IF NOT EXISTS `portfolio_healthcare.staging` OPTIONS(location='US');
CREATE SCHEMA IF NOT EXISTS `portfolio_healthcare.core` OPTIONS(location='US');
CREATE SCHEMA IF NOT EXISTS `portfolio_healthcare.marts` OPTIONS(location='US');
