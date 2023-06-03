import 'package:cosmetic_frontend/blocs/product_characteristic/product_characteristic_bloc.dart';
import 'package:cosmetic_frontend/blocs/review/review_bloc.dart';
import 'package:cosmetic_frontend/blocs/review_detail/review_detail_bloc.dart';
import 'package:cosmetic_frontend/models/models.dart';
import 'package:cosmetic_frontend/screens/onboard/onboard_screen.dart';
import 'package:cosmetic_frontend/screens/review/create_review_screen.dart';
import 'package:cosmetic_frontend/screens/review/review_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import './blocs/auth/auth_state.dart';
import './blocs/comment/comment_bloc.dart';
import './blocs/list_video/list_video_bloc.dart';
import './blocs/personal_info/personal_info_bloc.dart';
import './blocs/personal_post/personal_post_bloc.dart';
import './blocs/post/post_bloc.dart';
import './blocs/post_detail/post_detail_bloc.dart';
import './blocs/search/search_bloc.dart';
import './blocs/signup/signup_bloc.dart';
import './blocs/friend/friend_bloc.dart';
import './blocs/unknown_people/unknown_people_bloc.dart';
import './blocs/friend_request_received/friend_request_received_bloc.dart';
import './blocs/event/event_bloc.dart';
import './blocs/event_detail/event_detail_bloc.dart';
import './blocs/product/product_bloc.dart';
import './blocs/product_carousel/product_carousel_bloc.dart';

import 'blocs/product_detail/product_detail_bloc.dart';
import 'screens/nav_screen.dart';
import 'screens/screens.dart';
import 'repositories/repositories.dart';
import 'routes.dart';

import 'simple_bloc_observer.dart';
import 'constants/material/theme.dart';


void main() async{
  // debug global BLOC, suggesting turn off, please override in debug local BLOC
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return ErrorWidget(details.exception);
  };
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    PostRepository postRepository = PostRepository();
    VideoRepository videoRepository = VideoRepository();
    SignupRepository signupRepository = SignupRepository();
    FriendRequestReceivedRepository friendRequestReceivedRepository = FriendRequestReceivedRepository();
    EventRepository eventRepository = EventRepository();
    ProductRepository productRepository = ProductRepository();
    ReviewRepository reviewRepository = ReviewRepository();

    final theme = CosmeticTheme();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          lazy: false,
          create: (_) => AuthBloc()..add(KeepSession())
        ),
        BlocProvider<PostBloc>(
          lazy: false,
          create: (_) => PostBloc(postRepository: postRepository),
        ),
        BlocProvider<PostDetailBloc>(
          lazy: false,
          create: (_) => PostDetailBloc(postRepository: postRepository)
        ),
        BlocProvider<PersonalPostBloc>(
          lazy: false,
          create: (_) => PersonalPostBloc(postRepository: postRepository)
        ),
        BlocProvider<CommentBloc>(
          lazy: false,
          create: (_) => CommentBloc(),
        ),
        BlocProvider<ListVideoBloc>(
            lazy: false,
            create: (_) => ListVideoBloc(videoRepository: videoRepository)
        ),
        BlocProvider<FriendRequestReceivedBloc>(
            lazy: false,
            create: (_) => FriendRequestReceivedBloc()
        ),
        BlocProvider<PersonalInfoBloc>(
          lazy: false,
          create: (_) => PersonalInfoBloc(),
        ),
        BlocProvider<FriendBloc>(
          lazy: false,
          create: (_) => FriendBloc(),
        ),
        BlocProvider<SignupBloc>(
          lazy: false,
          create: (_) => SignupBloc(signupRepository: signupRepository),
        ),
        BlocProvider<UnknownPeopleBloc>(
          lazy: false,
          create: (_) => UnknownPeopleBloc(),
        ),
        BlocProvider<SearchBloc>(
          lazy: false,
          create: (_) => SearchBloc(),
        ),
        BlocProvider<ProductCarouselBloc>(
          lazy: false,
          create: (_) => ProductCarouselBloc(productRepository: productRepository),
        ),
        BlocProvider<EventBloc>(
          lazy: false,
          create: (_) => EventBloc(eventRepository: eventRepository),
        ),
        BlocProvider<EventDetailBloc>(
          lazy: false,
          create: (_) => EventDetailBloc(eventRepository: eventRepository),
        ),
        BlocProvider<ProductBloc>(
          lazy: false,
          create: (_) => ProductBloc(productRepository: productRepository)
        ),
        BlocProvider<ProductDetailBloc>(
          lazy: false,
          create: (_) => ProductDetailBloc(productRepository: productRepository)
        ),
        BlocProvider<ReviewBloc>(
          lazy: false,
          create: (_) => ReviewBloc(reviewRepository: reviewRepository)
        ),
        BlocProvider<ProductCharacteristicBloc>(
          lazy: false,
          create: (_) => ProductCharacteristicBloc(reviewRepository: reviewRepository)
        ),
        BlocProvider<ReviewDetailBloc>(
          lazy: false,
          create: (_) => ReviewDetailBloc(reviewRepository: reviewRepository)
        )
      ],
      child: MaterialApp(
        title: 'Fakebook',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.light(useMaterial3: true),
        theme: theme.toLightThemeData(),
        home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              switch (state.status) {
                case AuthStatus.unknown:
                  return LoginScreen();
                case AuthStatus.unauthenticated:
                  return LoginScreen();
                case AuthStatus.loginFail:
                  return LoginScreen(fail: true);
                case AuthStatus.authenticated:
                  return NavScreen();
                case AuthStatus.firstTimeUseApp:
                  return OnboardScreen();
              }
            }
        ),
        onGenerateRoute: (settings) {
            switch (settings.name) {
              // case Routes.home_screen:
              //   return MyApp(); // lỗi
              //   break;
              // Bởi vì cập nhật state bằng Bloc nên không cần push từ Login
              case Routes.login_screen:
                return MaterialPageRoute(builder: (_) => LoginScreen());
                break;
              case Routes.signup_screen:
                return MaterialPageRoute(builder: (_) => SignupScreen());
                break;
              case Routes.nav_screen:
                return MaterialPageRoute(builder: (_) => NavScreen());
                break;
              case Routes.post_detail_screen: {
                // return MaterialPageRoute(builder: (_) => PostDetailScreen()); // null arguments ???
                final postId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => PostDetailScreen(postId: postId));
              }
              case Routes.create_post_screen:
                return MaterialPageRoute(builder: (_) => CreatePostScreen());
              case Routes.emotion_screen:
                return MaterialPageRoute(builder: (_) => EmotionScreen());
              case Routes.personal_screen: {
                final String? accountId = settings.arguments as String?;
                return MaterialPageRoute(builder: (_) => PersonalScreen(accountId: accountId));
              }
              // case Routes.messenger_screen: {
              //   return MaterialPageRoute(builder: (_) => MessengerScreen());
              // }
              case Routes.friend_screen: {
                return MaterialPageRoute(builder: (_) => FriendScreen());
              }
              case Routes.unknown_people_screen: {
                return MaterialPageRoute(builder: (_) => UnknownPeopleScreen());
              }
              case Routes.request_friend_screen: {
                return MaterialPageRoute(builder: (_) => RequestFriendScreen());
              }
              case Routes.event_detail_screen: {
                final String eventId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: eventId));
              }
              case Routes.product_detail_screen: {
                // return MaterialPageRoute(builder: (_) => PostDetailScreen()); // null arguments ???
                final productId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: productId));
              }
              case Routes.quick_create_review_screen: {
                final String productId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => QuickCreateReviewScreen(productId: productId));
              }
              case Routes.standard_create_review_screen: {
                final args = settings.arguments as Map<String, dynamic>;
                final String productId = args["productId"];
                final String productImageUrl = args["productImageUrl"];
                final String productName = args["productName"];
                final int rating = args["rating"];
                return MaterialPageRoute(builder: (_) => StandardCreateReviewScreen(
                    productId: productId, productImageUrl: productImageUrl,
                    productName: productName, rating: rating
                ));
              }
              case Routes.detail_create_review_screen: {
                final args = settings.arguments as Map<String, dynamic>;
                final String productId = args["productId"];
                final String productImageUrl = args["productImageUrl"];
                final String productName = args["productName"];
                final int rating = args["rating"];
                return MaterialPageRoute(builder: (_) => DetailCreateReviewScreen(
                    productId: productId, productImageUrl: productImageUrl,
                    productName: productName, rating: rating
                ));
              }
              case Routes.instruction_create_review_screen: {
                final String productId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => InstructionCreateReviewScreen(productId: productId));
              }
              case Routes.product_characteristic_screen: {
                final String productId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => ProductCharacteristicScreen(productId: productId));
              }
              case Routes.review_detail_screen: {
                final String reviewId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => ReviewDetailScreen(reviewId: reviewId));
              }
              default:
                return MaterialPageRoute(builder: (_) => NavScreen());
            }
        }
      ),
    );
  }
}
