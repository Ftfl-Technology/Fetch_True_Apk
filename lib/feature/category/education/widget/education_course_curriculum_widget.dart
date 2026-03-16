import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../model/education_service_details_model.dart' show CourseCurriculum;
import '../screen/education_service_details_screen.dart';

class EducationCourseCurriculumWidget extends StatefulWidget {
  final List<CourseCurriculum> courseCurriculum;

  const EducationCourseCurriculumWidget({
    super.key,
    required this.courseCurriculum,
  });

  @override
  State<EducationCourseCurriculumWidget> createState() =>
      _EducationCourseCurriculumWidgetState();
}

class _EducationCourseCurriculumWidgetState
    extends State<EducationCourseCurriculumWidget> {
  int? expandedIndex;
  int selectedModuleIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SymbolText(text: 'Course Curriculum'),
          const SizedBox(height: 15),
          Column(
            spacing: 10,
            children: List.generate(widget.courseCurriculum.length, (index) {
              final item = widget.courseCurriculum[index];
              final isExpanded = expandedIndex == index;
              final indexList = index + 1;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            color: CustomColor.education),
                        child: Text(
                          'Section ${indexList}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 18,
                            color: CustomColor.appColor,
                          ),
                          Text(
                            'Vigit Aatrey',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey.shade700),
                          ),
                        ],
                      )
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Toggle Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            InkWell(
                              child: Icon(
                                size: 26,
                                color: CustomColor.education,
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                              ),
                              onTap: () {
                                setState(() {
                                  expandedIndex = isExpanded ? null : index;
                                });
                              },
                            ),
                          ],
                        ),
                        10.height,

                        Wrap(
                          spacing: 8,        // horizontal gap
                          runSpacing: 6,     // vertical gap
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            item.lists.length,
                                (i) => CustomContainer(
                              margin: EdgeInsets.zero,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              child: Text(
                                item.lists[i],
                                style:  TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        10.height,

                        /// Expandable Content
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: isExpanded
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              20.height,

                              /// Module Tabs
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(item.model.length, (mIndex) {
                                    final moduleIndex = mIndex + 1;
                                    final isSelected = selectedModuleIndex == mIndex;

                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedModuleIndex = mIndex;
                                        });
                                      },
                                      child: Container(
                                        // margin: const EdgeInsets.only(right: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? CustomColor.education
                                              : Colors.grey.shade200,
                                          // borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isSelected ?'Module $moduleIndex' : "${moduleIndex}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                            isSelected ? Colors.white : Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),

                              10.height,

                              Html(
                                data: item.model[selectedModuleIndex],
                                style: {
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    lineHeight: LineHeight.number(1.4),
                                    color: Colors.grey.shade500,
                                  ),
                                  "li": Style(
                                  ),
                                  "table": Style(
                                  ),
                                  "th": Style(
                                  ),
                                  "td": Style(
                                  ),
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                  ),
                                  "br": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                  )
                                },
                              ),
                            ],
                          )
                              : const SizedBox(),
                        ),

                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
