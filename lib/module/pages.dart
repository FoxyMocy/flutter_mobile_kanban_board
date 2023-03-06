import 'dart:math';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kanban_project/module/widgets.dart';
import 'package:kanban_project/services/services.dart';
import 'package:kanban_project/themes/themes.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

part './main_page/main_page.dart';
part './auth_page/signin_page.dart';
part './board_detail/board_detail.dart';
part './auth_page/auth.dart';
part './widget_tree.dart';
