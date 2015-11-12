/*
 * Copyright 2015 Follow My Vote, Inc.
 * This file is part of The Follow My Vote Stake-Weighted Voting Application ("SWV").
 *
 * SWV is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SWV is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with SWV.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

import Material 0.1

import FollowMyVote.StakeWeightedVoting 1.0

Page {
    id: feedPage
    title: qsTr("All Polls")
    actionBar.maxActionCount: 3

    function reloadContests() { contestList.reload() }

    actions: [
        Action {
            name: qsTr("Find Polls")
            iconName: "action/search"
        },
        Action {
            name: qsTr("Notifications")
            iconName: "social/notifications_none"
        },
        Action {
            name: qsTr("Reload Polls")
            iconName: "navigation/refresh"
            onTriggered: reloadContests()
        },
        Action {
            name: qsTr("Settings")
            iconName: "action/settings"
        },
        Action {
            name: qsTr("Help")
            iconName: "action/help"
        },
        Action {
            name: qsTr("Send Feedback")
            iconName: "action/feedback"
        }

    ]

    ContestantDetailDialog {
        id: contestantDetailDialog
        width: feedPage.width * .75
    }
    ListModel {
        id: contestList

        function reload() {
            contestList.clear()
            // TODO: Fix hard-coded 2, and fetch contests to fill screen, handling out of contests case
            votingSystem.backend.getContests(2).then(function (contests) {
                contests.forEach(function(contest) {
                    contestList.append(Object(contest))
                })
            })
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: Units.dp(8)
        anchors.bottomMargin: Units.dp(8)
        model: contestList
        delegate: ContestCard{}
        spacing: Units.dp(8)

        PullToRefresh {
            view: parent
            onTriggered: contestList.reload()
            text: fullyPulled? qsTr("Release to Refresh") : qsTr("Pull to Refresh")
        }

        Column {
            anchors.centerIn: parent
            visible: contestList.count === 0
            ProgressCircle {
                width: height
                height: feedPage.height / 10
                anchors.horizontalCenter: parent.horizontalCenter

                NumberAnimation {
                    target: parent
                    property: "value"
                    duration: 200
                    from: 0; to: 1
                    loops: Animation.Infinite
                }
            }
            Label {
                text: qsTr("Loading Polls")
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}