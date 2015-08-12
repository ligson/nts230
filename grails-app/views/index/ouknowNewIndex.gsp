<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 5/21/14
  Time: 9:54 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <meta name="layout" content="index">
    <title>jQuery UI Autocomplete - Combobox</title>
    <link rel="stylesheet" type="text/css"
          href="${resource(dir: 'skin/blue/pc/admin/css', file: 'jquery-ui-1.10.4.css')}">
    <script type="text/javascript" src="${resource(dir: 'js/adminButton', file: 'jquery-1.10.2.js')}"></script>
    <script type="text/javascript" src="${resource(dir: 'js/adminButton', file: 'jquery-ui-1.10.4.js')}"></script>
    %{--<link rel="stylesheet" href="/resources/demos/style.css">--}%
    <style>
    .custom-combobox {
        position: relative;
        display: inline-block;
    }

    .custom-combobox-toggle {
        position: absolute;
        top: 0;
        bottom: 0;
        margin-left: -1px;
        padding: 0;
        /* support: IE7 */
        *height: 1.7em;
        *top: 0.1em;
    }

    .custom-combobox-button {
        margin: 0;
        padding: 0.3em;
    }

    .ui_in_cus {
        width: 100px;
        line-height: 1em;
        height: 2em;
    }
    </style>
    <script>
        (function ($) {
            $.widget("custom.combobox", {
                _create: function () {
                    this.wrapper = $("<span>")
                            .addClass("custom-combobox")
                            .insertAfter(this.element);

                    this.element.hide();
                    this._createAutocomplete();
                    this._createShowAllButton();
                },

                _createAutocomplete: function () {
                    var selected = this.element.children(":selected"),
                            value = selected.val() ? selected.text() : "";

                    this.button = $("<button>")
                            .appendTo(this.wrapper)
                            .val(value)
                            .attr("title", "")
                            .addClass("custom-combobox-button ui-widget ui-widget-content ui-state-default ui-corner-left ui_in_cus")
                            .autocomplete({
                                delay: 0,
                                minLength: 0,
                                source: $.proxy(this, "_source")
                            })
                            .tooltip({
                                tooltipClass: "ui-state-highlight"
                            });

                    this._on(this.button, {
                        autocompleteselect: function (event, ui) {
                            ui.item.option.selected = true;
                            this._trigger("select", event, {
                                item: ui.item.option
                            });
                        },

                        autocompletechange: "_removeIfInvalid"
                    });
                },

                _createShowAllButton: function () {
                    var button = this.button,
                            wasOpen = false;

                    $("<a>")
                            .attr("tabIndex", -1)
                            .attr("title", "Show All Items")
                            .tooltip()
                            .appendTo(this.wrapper)
                            .button({
                                icons: {
                                    primary: "ui-icon-triangle-1-s"
                                },
                                text: false
                            })
                            .removeClass("ui-corner-all")
                            .addClass("custom-combobox-toggle ui-corner-right")
                            .mousedown(function () {
                                wasOpen = button.autocomplete("widget").is(":visible");
                            })
                            .click(function () {
                                button.focus();

                                // Close if already visible
                                if (wasOpen) {
                                    return;
                                }

                                // Pass empty string as value to search for, displaying all results
                                button.autocomplete("search", "");
                            });
                },

                _source: function (request, response) {
                    var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
                    response(this.element.children("option").map(function () {
                        var text = $(this).text();
                        if (this.value && ( !request.term || matcher.test(text) ))
                            return {
                                label: text,
                                value: text,
                                option: this
                            };
                    }));
                },

                _removeIfInvalid: function (event, ui) {

                    // Selected an item, nothing to do
                    if (ui.item) {
                        return;
                    }

                    // Search for a match (case-insensitive)
                    var value = this.button.val(),
                            valueLowerCase = value.toLowerCase(),
                            valid = false;
                    this.element.children("option").each(function () {
                        if ($(this).text().toLowerCase() === valueLowerCase) {
                            this.selected = valid = true;
                            return false;
                        }
                    });

                    // Found a match, nothing to do
                    if (valid) {
                        return;
                    }

                    // Remove invalid value
                    this.button
                            .val("")
                            .attr("title", value + " didn't match any item")
                            .tooltip("open");
                    this.element.val("");
                    this._delay(function () {
                        this.button.tooltip("close").attr("title", "");
                    }, 2500);
                    this.button.data("ui-autocomplete").term = "";
                },

                _destroy: function () {
                    this.wrapper.remove();
                    this.element.show();
                }
            });
        })(jQuery);

        $(function () {
            $("#combobox").combobox();
            $("#toggle").click(function () {
                $("#combobox").toggle();
            });
        });
    </script>
</head>

<body>
<div style="width: 1024px; height: 300px; margin: 200px auto">
    <div class="ui-widget">
        <select id="combobox">
            <option value="">Select one...</option>
            <option value="ActionScript">ActionScript</option>
            <option value="AppleScript">AppleScript</option>
            <option value="Asp">Asp</option>
            <option value="BASIC">BASIC</option>
            <option value="C">C</option>
            <option value="C++">C++</option>
            <option value="Clojure">Clojure</option>
            <option value="COBOL">COBOL</option>
        </select>
    </div>

</div>
</body>
</html>