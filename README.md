## Inspiration
With the fast pace of life, people could easily forget the stuff they bought. One day when they suddenly remembered, it is already expired. Many wastes of resources have been created during the process. The wastes became an inequity for people who are struggling to get the basic supply for living. Therefore, it came to our mind to create an App that helps people to remember the expiration date for the product.  In this way, it might help people to create less waste and cultivate equity and access for everyone tomorrow.

## What it does
This IOS Application enables people to add a list of product that you own and send you a notification at the time you set as a reminder date. With the application, you can take pictures of the barcode of a product, and it will recognize the product for you, or you can manually add the product. Then, you will be able to set a category, an expiration date, a notification date for that product. The application would send you a notification when it is the time.

## How we built it
We utilized iOS native Camera and Album Access to get an image of a product's barcode. Haven on Demand's API call for barcode recognition, and Buycott's API call to obtain item information. Haven on Demand's service runs on AWS and our application runs on UW PHP server. Moreover, we used iOS datepicker to allow the users to specify the date to expire and a custom entry of sending a notification before certain days. Lastly, we utilized the iOS native notification system to schedule a notification based on the user's preference and display the items to expire sorted in a listview. 

## Challenges we ran into
We spent a hard time looking for accessible and accurate barcode recognition APIs. It turned out that it was not easy.
Besides, Dealing with incompatibilities and syntax resulted from the switch between Swift3 and Swift4 was also a challenge. 

## Accomplishments that we're proud of
We finally got the application run on our iPhones and it can recognize barcode well and send notifications correctly. 

## What we learned
We learned how to utilize API to recognize barcode and design and build an iOS app from scratch in such a short amount of time.

## What's next for No Regret
It could have a better UI design and picture recognition for the product expiration date. Also, We could enable recipe recognition that makes the entry experience better in the future. Moreover, once we have enough user-generated purchase related data, we can drive more innovations to build technologies that truly work for people and make a difference.
