%%%MetaData
status: Live
author: Adrian Woodcock <adrian.woodcock@digital.justice.gov.uk>
description: Make a claim to evict your tenants using the accelerated possession procedure if they’re on an assured shorthold tenancy.
lastUpdated: 3/11/2014
department: MOJ DS
tags: exemplar, HMCTS, civil claims, rails
type: service
%%%

# Accelerated Claim app

This is the source code of what is currently a minimum viable product for the Civil Claims exemplar. The application consists in a single form that claimants of accelerated claims fill out to download a PDF. The PDF is the standard N5b “Accelerated property possession claim” form from HMCTS, is filled out with the details that the claimant has provided, and can be signed and sent by post.


The scope of this phase of work is to digitise and improve the user experience of the form.

We are focusing on:

* helping users to understand what is being requested of them to complete this service
* helping first time users understand the information they are submitting
* reducing errors made in completion of the form
* reducing duplication necessary on the written form 

# Primary User Needs

As a claimant (private landlord) user I want:

* to feel more confident that I have filled it in correctly
* to be able to fill in the form efficiently

As a court staff user I want:

* (long term benefit) to reduce the number of errors made on a form when submitted to court
* to reduce the number of customer service calls to call centers/courts

# Components
This service requires the `strike2` component.
%%%Component
name: strike2
description: App for crossing sections in PDF documents
link: strike2
%%%
Used for striking out sections of the generate PDF

