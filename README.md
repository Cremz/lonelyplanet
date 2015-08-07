# lonelyplanet
Lonelyplanet code challenge

Implementation description

Assuming that the XML files are just very badly done, but not invalid, I started by reading the files using Nokogiri and then parsing them into a hash using the Rails active support tool. This proved to be a very fast solution as it helped generate a hash that was more manageable than the initial XML.

From there, I created two classes, one for the Taxonomy which describes the links between pages and one for the Destination, which saves a brief summary of each destination. I chose this summary to insert into the pages, but any other content could have been accessed.

#Taxonomy
It goes through the hash that was created by reading the taxonomy.xml and generates another hash of all destinations with their ID, name and the parent they might have. It goes through all the levels of the initial XML (again, assuming that all input files follow the same pattern) and returns all destinations.

There are two methods, one that finds all the children and one that finds the parent of a given destination. This is used to generate the hierarchy links.

#Destination
It parses the destination.xml file and generates an array with hashes containing the ID, destination name and the short description used in the output template. It also implements a finder method to select the array elements that matches a given ID.

#LonelyPlanetParser
The main class has an initializer that gets the two source xml files and creates instances of the two model classes. Then, for each country in the taxonomy.content array, it calls the generate_document method which writes the required info to a file with the destination id as a filename.

#Running the app
