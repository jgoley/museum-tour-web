legacyTours=
[
    {
        "tourID": 1,
        "tourType": 0,
        "baseNum": 100,
        "mainTitle": "Japan & the Jazz Age",
        "subTitle":  "",
        "openDate": "2014-02-07",
        "closeDate": "2014-04-20",
        "image": "japan.jpg",
        "menu": 1,
        "icon": 1
    },
    {
        "tourID": 2,
        "tourType": 1,
        "baseNum": 100,
        "mainTitle": "Japan & the Jazz Age",
        "subTitle": "",
        "openDate": "2014-02-07",
        "closeDate": "2014-04-20",
        "image": "japan-family.jpg",
        "menu": 0,
        "icon": 2
    },
    {
        "tourID": 3,
        "tourType": 0,
        "baseNum": 100,
        "mainTitle": "Meiji Magic",
        "subTitle": "",
        "openDate": "2014-01-03",
        "closeDate": "2014-05-01",
        "image": "meiji.jpg",
        "menu": 0,
        "icon": ""
    },
    {
        "tourID": 4,
        "tourType": 0,
        "baseNum": 100,
        "mainTitle": "Animal Instinct",
        "subTitle": "Paintings by Shelley Reed",
        "openDate": "2014-05-16",
        "closeDate": "2014-09-14",
        "image": "meiji.jpg",
        "menu": 0,
        "icon": 1
    },
    {
        "tourID": 5,
        "tourType": 2,
        "baseNum": 100,
        "mainTitle": "Animal Instinct and Cheer for the Home Team!",
        "subTitle": "",
        "openDate": "2014-05-16",
        "closeDate": "2014-09-14",
        "image": "meiji.jpg",
        "menu": 0,
        "icon": 2
    },
    {
        "tourID": 6,
        "tourType": 0,
        "baseNum": 100,
        "mainTitle": "Norman Rockwell",
        "subTitle": "Behind the Camera",
        "openDate": "2014-10-17",
        "closeDate": "2015-01-18",
        "image": "rockwell.jpg",
        "menu": 0,
        "icon": 1
    },
    {
        "tourID": 7,
        "tourType": 0,
        "baseNum": 100,
        "mainTitle": "Charles Courtney Curran",
        "subTitle": "Seeking the Ideal",
        "openDate": "2015-02-20",
        "closeDate": "2015-05-17",
        "image": "curran.jpg",
        "menu": 0,
        "icon": 1
    },
    {
        "tourID": 8,
        "tourType": 1,
        "baseNum": 100,
        "mainTitle": "Charles Courtney Curran"
        "subTitle": "Seeking the Ideal",
        "openDate": "2015-02-20",
        "closeDate": "2015-05-17",
        "image": "curran.jpg",
        "menu": 0,
        "icon": 2
    },
    {
        "tourID":"9",
        "tourType": 0,
        "baseNum": 100,
        "mainTitle":"From Marilyn to Mao",
        "subTitle": "Andy Warhol's Famous Faces",
        "openDate":"2015-06-12",
        "closeDate":"2015-09-13",
        "image":"warhol.jpg",
        "menu": 0,
        "icon":1
  },
  {
        "tourID":"10",
        "tourType": 1,
        "baseNum": 200,
        "mainTitle":"From Marilyn to Mao",
        "subTitle": "Andy Warhol's Famous Faces",
        "openDate":"2015-06-12",
        "closeDate":"2015-09-13",
        "image":"warhol.jpg",
        "menu":0,
        "icon":2
  }
]

tours =
  _.chain(legacyTours)
    .map((tour)->
      'tourID': tour.tourID
      'mainTitle': tour.mainTitle,
      'subTitle': tour.subTitle,
      'openDate': new Date(tour.openDate),
      'closeDate': new Date(tour.closeDate),
      'baseNum': tour.baseNum,
      'tourType': tour.tourType,
      'menu': if tour.menu is 0 then false else true,
      'image': tour.image,
      'stops': []
      )
    .value()

Tours = () ->
  @Tap.Collections.Tours

Meteor.startup () ->
  unless Tours().findOne({})
    _.each tours, (tour) ->
      Tours().insert(tour)
  console.log tours
