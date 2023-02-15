import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:stopped_watch/color_schemes.g.dart';
import 'package:stopped_watch/cubit/record/record_cubit.dart';
import 'package:stopped_watch/data/category_model.dart';
import 'package:stopped_watch/rounded_button.dart';
import 'package:stopped_watch/ui/main_page.dart';

class RecordPage extends StatefulWidget {
  final CategoryModel categoryObject;
  final VoidCallback renderFunction;

  const RecordPage(
      {Key? key, required this.categoryObject, required this.renderFunction})
      : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  int min = 0;
  int sec = 0;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _stopWatchTimer.rawTime.listen((value) =>
    //     print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    // _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    // _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    // _stopWatchTimer.records.listen((value) => print('records $value'));
    // _stopWatchTimer.fetchStopped
    //     .listen((value) => print('stopped from stream'));
    // _stopWatchTimer.fetchEnded.listen((value) => print('ended from stream'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryObject.category),
        titleTextStyle: const TextStyle(fontSize: 32),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (widget.categoryObject.recordsList.isNotEmpty)
              Expanded(
                flex: 9,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 20),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                (widget.categoryObject.recordsList[index]
                                            .index +
                                        1)
                                    .toString(),
                                style: const TextStyle(fontSize: 32)),
                            Text(
                                widget.categoryObject.recordsList[index]
                                    .recordedTime,
                                style: const TextStyle(fontSize: 24))
                          ],
                        ),
                        // subtitle: ,
                        trailing: IconButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete Category'),
                              content: Text(
                                  'Do you want to delete ${index + 1}. Record'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.categoryObject.recordsList
                                          .removeAt(index);
                                      widget.categoryObject.average =
                                          giveAverage(
                                              recordsList: widget
                                                  .categoryObject.recordsList);
                                    });
                                    context.read<RecordCubit>().saveRecords();
                                    widget.renderFunction();
                                    Navigator.pop(context, 'OK');
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                          icon: const Icon(Icons.remove_circle),
                        ),
                        tileColor: darkColorScheme.secondaryContainer,
                      ),
                    );
                  },
                  itemCount: widget.categoryObject.recordsList.length,
                ),
              )
            else
              const Expanded(
                  flex: 9,
                  child: Center(
                      child: Text(
                    "Add Records",
                    style: TextStyle(fontSize: 32),
                  ))),
            Expanded(
              flex: 6,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Stack(alignment: Alignment.center, children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF302D38),
                        borderRadius: BorderRadius.circular(28)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        /// Display every minute.
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: StreamBuilder<int>(
                                  stream: _stopWatchTimer.minuteTime,
                                  initialData: _stopWatchTimer.minuteTime.value,
                                  builder: (context, snap) {
                                    final value2 = snap.data;
                                    final value = value2! % 60;
                                    min = value;

                                    return Container(
                                      decoration: BoxDecoration(
                                          color: darkColorScheme.surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: darkColorScheme
                                                    .surfaceVariant,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Text(
                                                "${value! < 10 ? '0$value' : value}",
                                                style: const TextStyle(
                                                    fontSize: 45,
                                                    fontFamily: 'Helvetica',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  ":",
                                  style: TextStyle(
                                      fontSize: 45,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: StreamBuilder<int>(
                                  stream: _stopWatchTimer.secondTime,
                                  initialData: _stopWatchTimer.secondTime.value,
                                  builder: (context, snap) {
                                    final value2 = snap.data;
                                    final value = value2! % 60;
                                    sec = value;

                                    return Container(
                                      decoration: BoxDecoration(
                                          color: darkColorScheme.surfaceVariant,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Text(
                                              "${value! < 10 ? '0$value' : value}",
                                              style: const TextStyle(
                                                fontSize: 45,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Display every second.

                        /// Lap time.

                        /// Button
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: RoundedButton(
                                color: Colors.lightBlue,
                                onTap: _stopWatchTimer.onStartTimer,
                                child: const Text(
                                  'Start',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: RoundedButton(
                                color: Colors.green,
                                onTap: _stopWatchTimer.onStopTimer,
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: RoundedButton(
                                color: Colors.red,
                                onTap: () {
                                  _stopWatchTimer.onResetTimer();
                                },
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0)
                                        .copyWith(right: 8),
                                    child: RoundedButton(
                                      color: Colors.deepPurpleAccent,
                                      onTap: () {
                                        if (min == 0 && sec == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      "You must first Start the Stop Watch")));
                                        } else {
                                          print("$min:$sec");
                                          final String recMin = min < 10
                                              ? "0$min"
                                              : min.toString();
                                          final String recSec = sec < 10
                                              ? "0$sec"
                                              : sec.toString();
                                          final String recordedTime =
                                              "$recMin:$recSec";
                                          final int time = min * 60 + sec;
                                          // final int
                                          setState(() {
                                            widget.categoryObject.recordsList
                                                .add(RecordModel(
                                                    index: widget.categoryObject
                                                        .recordsList.length,
                                                    time: time,
                                                    recordedTime:
                                                        recordedTime));
                                            widget.categoryObject.average =
                                                giveAverage(
                                                    recordsList: widget
                                                        .categoryObject
                                                        .recordsList);
                                          });

                                          context
                                              .read<RecordCubit>()
                                              .saveRecords();
                                          widget.renderFunction();
                                        }
                                        // _stopWatchTimer.onAddLap();
                                      },
                                      child: const Text(
                                        'Lap',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int giveAverage({required List<RecordModel> recordsList}) {
    int average = 0;
    for (RecordModel record in recordsList) {
      average += record.time;
    }
    try {
      average = average ~/ recordsList.length;
    } catch (e) {
      average = 0;
    }
    return average;
  }
}
