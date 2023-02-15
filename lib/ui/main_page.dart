import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopped_watch/color_schemes.g.dart';
import 'package:stopped_watch/cubit/record/record_cubit.dart';
import 'package:stopped_watch/data/category_model.dart';
import 'package:stopped_watch/ui/record_page.dart';

// final List<CategoryModel> categoryList = [];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RecordCubit>().getRecords();
  }

  reRenderTheWidget() {
    setState(() {
      context.read<RecordCubit>().categoryList;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopped Watch'),
        titleTextStyle: const TextStyle(fontSize: 32),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 9,
                child: BlocBuilder<RecordCubit, RecordState>(
                    buildWhen: (previous, current) =>
                        current is RecordIdleState ||
                        current is GotRecordsState ||
                        current is NoRecordsState,
                    builder: (context, state) {
                      if (state is GotRecordsState) {
                        if (context
                            .read<RecordCubit>()
                            .categoryList
                            .isNotEmpty) {
                          return ListView.builder(
                            itemBuilder: (context, index) {
                              final int average = context
                                  .read<RecordCubit>()
                                  .categoryList[index]
                                  .average;
                              int minutes = (average ~/ 60);
                              int seconds = average % 60;
                              final String prompt =
                                  "${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}";

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 20),
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () => showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Delete Category'),
                                        content: Text(
                                            'Do you want to delete ${context.read<RecordCubit>().categoryList[index].category} Category'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                context
                                                    .read<RecordCubit>()
                                                    .categoryList
                                                    .removeAt(index);
                                              });
                                              context
                                                  .read<RecordCubit>()
                                                  .saveRecords();
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          context
                                              .read<RecordCubit>()
                                              .categoryList[index]
                                              .category,
                                          style: const TextStyle(fontSize: 32)),
                                      Text(prompt,
                                          style: const TextStyle(fontSize: 24))
                                    ],
                                  ),
                                  // subtitle: ,
                                  onTap: () {
                                    // CountUpTimerPage.navigatorPush(context);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => RecordPage(
                                          categoryObject: context
                                              .read<RecordCubit>()
                                              .categoryList[index],
                                        renderFunction: reRenderTheWidget
                                      ),
                                    ));
                                  },
                                  tileColor: darkColorScheme.secondaryContainer,
                                ),
                              );
                            },
                            itemCount:
                                context.read<RecordCubit>().categoryList.length,
                          );
                        } else {
                          return const Center(
                              child: Text(
                            "You can add a category",
                            style: TextStyle(fontSize: 32),
                          ));
                        }
                      } else if (state is NoRecordsState) {
                        return const Center(
                          child: Text("You can add a category",
                              style: TextStyle(fontSize: 32)),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })),
            Expanded(
              flex: 1,
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  color: darkColorScheme.background,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColorScheme.surfaceTint,
                    foregroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.all(4),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Add Category'),
                        content: TextField(controller: _controller),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (_controller.text.isNotEmpty) {
                                  context.read<RecordCubit>().categoryList.add(
                                      CategoryModel(
                                          category: _controller.text,
                                          average: 0,
                                          recordsList: <RecordModel>[]));
                                }
                                context.read<RecordCubit>().saveRecords();
                              });

                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Add Category',
                      style: TextStyle(color: darkColorScheme.onPrimary),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
