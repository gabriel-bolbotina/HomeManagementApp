import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeapp/Pages/model/User.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final Users _user;
  DatabaseService(this._user, this.firstName);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User currentUser;

  late final String firstName;



  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        print(currentUser.email);
      }
    } catch (e) {
      print(e);
    }
  }


  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // update user data
  Future updateUserData(String firstName, String lastName,
      int age, String role) async {
    getCurrentUser();
    return await userCollection.doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'first name': firstName,
      'last name': lastName,
      'age' : age,
      'role': role,
    });
  }

  // get user data
  Future getUserData() async {
    QuerySnapshot snapshot = await userCollection.where('uid', isEqualTo: currentUser.uid).get();
    return snapshot;
  }

  Future<String?> getUserField(String s)
  async {
    QuerySnapshot snapshot = await userCollection.where('uid', isEqualTo: currentUser.uid).get();
   Users.fromSnapshot(snapshot);
   firstName = _user.firstName!;
   return null;
  }

  String getFirstName()
  {
    return firstName;
  }


  /*
  // save blog post
  Future saveBlogPost(String title, String author, String authorEmail, String content) async {
    DocumentReference blogPostsRef = await FireFirestore.instance.collection('blogPosts').add({
      'userId': uid,
      'blogPostId': '',
      'blogPostTitle': title,
      'blogPostTitleArray': title.toLowerCase().split(" "),
      'blogPostAuthor': author,
      'blogPostAuthorEmail': authorEmail,
      'blogPostContent': content,
      'likedBy': [],
      'createdAt': new DateTime.now(),
      'date': DateFormat.yMMMd('en_US').format(new DateTime.now())
    });

    await blogPostsRef.updateData({
      'blogPostId': blogPostsRef.documentID
    });

    return blogPostsRef.documentID;
  }

  // get user blog posts
  getUserBlogPosts() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance.collection('blogPosts').where('userId', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots();
  }

  // get blog post details
  Future getBlogPostDetails(String blogPostId) async {

    QuerySnapshot snapshot = await Firestore.instance.collection('blogPosts').where('blogPostId', isEqualTo: blogPostId).getDocuments();
    BlogPostDetails blogPostDetails = new BlogPostDetails(
      blogPostTitle: snapshot.documents[0].data['blogPostTitle'],
      blogPostAuthor: snapshot.documents[0].data['blogPostAuthor'],
      blogPostAuthorEmail: snapshot.documents[0].data['blogPostAuthorEmail'],
      blogPostContent: snapshot.documents[0].data['blogPostContent'],
      date: snapshot.documents[0].data['date'],
    );

    return blogPostDetails;
  }

  // search blogposts
  searchBlogPostsByName(String blogPostName) async {
    List<String> searchList = blogPostName.toLowerCase().split(" ");
    QuerySnapshot snapshot = await  Firestore.instance.collection('blogPosts').where('blogPostTitleArray', arrayContainsAny: searchList).getDocuments();
    // print(snapshot.documents.length);

    return snapshot;
  }


  // search users by name
  searchUsersByName(String userName) async {
    List<String> searchList = userName.toLowerCase().split(" ");
    QuerySnapshot snapshot = await  Firestore.instance.collection('users').where('fullNameArray', arrayContainsAny: searchList).getDocuments();
    print(snapshot.documents.length);

    return snapshot;
  }

  // liked blog posts
  Future togglingLikes(String blogPostId) async {
    DocumentReference userRef = userCollection.document(uid);
    DocumentSnapshot userSnap = await userRef.get();

    DocumentReference blogPostRef = Firestore.instance.collection('blogPosts').document(blogPostId);

    List<dynamic> likedPosts = await userSnap.data['likedPosts'];

    if(likedPosts.contains(blogPostId)) {
      userRef.updateData(
          {
            'likedPosts': FieldValue.arrayRemove([blogPostId])
          }
      );
      blogPostRef.updateData(
          {
            'likedBy': FieldValue.arrayRemove([uid])
          }
      );
    }
    else {
      userRef.updateData(
          {
            'likedPosts': FieldValue.arrayUnion([blogPostId])
          }
      );
      blogPostRef.updateData(
          {
            'likedBy': FieldValue.arrayUnion([uid])
          }
      );
    }
  }

   */
}
