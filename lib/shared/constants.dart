import 'package:flutter/material.dart';

 InputDecoration textInputDecoration =  InputDecoration(
                              hintStyle: const TextStyle(color: Colors.cyanAccent),
                              fillColor: Colors.black54,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.cyanAccent, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                                borderSide:
                                    const BorderSide(color: Colors.purpleAccent, width: 2.0),
                              ),
                            );