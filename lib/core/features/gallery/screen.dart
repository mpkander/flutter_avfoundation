import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transparent_image/transparent_image.dart';

import 'bloc.dart';

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state is GalleryStateFailure) {
            return _FailureWidget();
          } else if (state is GalleryStateLoading) {
            return _LoadingWidget();
          } else if (state is GalleryStateSuccess) {
            return _SuccessWidget(state: state);
          }

          throw StateError("unknown state");
        },
      ),
    );
  }
}

class _FailureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Something went wrong"),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }
}

class _SuccessWidget extends StatelessWidget {
  final GalleryStateSuccess state;

  late final List<ImageProvider> photos;

  _SuccessWidget({
    Key? key,
    required this.state,
  }) : super(key: key) {
    photos = state.photos.map((e) => FileImage(e.file)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [],
      body: GridView.builder(
        itemCount: photos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (_, index) => FadeInImage(
          placeholder: MemoryImage(kTransparentImage),
          image: photos[index],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
