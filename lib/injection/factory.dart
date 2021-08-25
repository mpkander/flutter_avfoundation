import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/features/camera/bloc.dart';
import '../core/features/camera/repository.dart';
import '../core/features/camera/screen.dart';
import '../platform/image_storage/image_storage.dart';

class FeatureFactory {
  final BlocFactory _blocFactory;

  FeatureFactory(this._blocFactory);

  Widget camera() => BlocProvider(
        create: (_) => _blocFactory.camera(),
        child: CameraScreen(),
      );

  static FeatureFactory compose() =>
      FeatureFactory(BlocFactory(RepositoryFactory()));
}

class BlocFactory {
  final RepositoryFactory _repositoryFactory;

  BlocFactory(this._repositoryFactory);

  CameraBloc camera() => CameraBloc(_repositoryFactory.camera());
}

class RepositoryFactory {
  CameraRepository camera() => CameraRepositoryImpl(ImageStoragePlatformImpl());
}
