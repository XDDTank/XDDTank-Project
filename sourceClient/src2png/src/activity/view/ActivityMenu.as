// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityMenu

package activity.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import activity.ActivityModel;
    import activity.ActivityController;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.MouseEvent;
    import activity.data.ActivityInfo;
    import activity.data.ActivityTypes;
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import __AS3__.vec.*;

    public class ActivityMenu extends Sprite implements Disposeable 
    {

        public static const MENU_REFRESH:String = "activitymenu_refresh";

        private var _cell:Vector.<ActivityItem> = new Vector.<ActivityItem>();
        private var _model:ActivityModel;
        private var _contentHolder:ActivityContentHolder;
        private var _selectedItemNew:ActivityItem;
        private var _askCellVec:Vector.<ActivityItem>;

        public function ActivityMenu()
        {
            this._model = ActivityController.instance.model;
            this.configUI();
        }

        private function cleanCells():void
        {
            var _local_1:ActivityItem = this._cell.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1.removeEventListener(MouseEvent.CLICK, this.__cellClick);
                _local_1 = this._cell.shift();
            };
        }

        public function setActivityDate(_arg_1:Date):void
        {
            var _local_2:ActivityItem;
            var _local_3:ActivityInfo;
            var _local_4:ActivityItem;
            this.cleanCells();
            this._askCellVec = new Vector.<ActivityItem>();
            for each (_local_3 in this._model.activityInfoArr)
            {
                if (((_local_3.ActivityType >= 0) && (ActivityController.instance.isInValidShowDate(_local_3))))
                {
                    if (ActivityController.instance.checkOpenActivity(_local_3))
                    {
                        _local_2 = new ActivityItemOpen(_local_3);
                    }
                    else
                    {
                        _local_2 = new ActivityItem(_local_3);
                    };
                    _local_2.addEventListener(MouseEvent.CLICK, this.__cellClick);
                    this._askCellVec.push(_local_2);
                };
            };
            for each (_local_4 in this._askCellVec)
            {
                ActivityController.instance.sendAskForActiviLog(_local_4.info);
            };
        }

        public function updateData(_arg_1:ActivityInfo):void
        {
            var _local_2:ActivityItem;
            var _local_3:ActivityItem;
            var _local_4:Vector.<ActivityItem>;
            var _local_5:Vector.<ActivityItem>;
            var _local_6:Vector.<ActivityItem>;
            var _local_7:Vector.<ActivityItem>;
            var _local_8:ActivityItem;
            var _local_9:ActivityItem;
            var _local_10:ActivityItem;
            var _local_11:ActivityItem;
            var _local_12:Vector.<ActivityItem>;
            if (this._askCellVec)
            {
                for each (_local_2 in this._askCellVec)
                {
                    if (_local_2.info.ActivityId == _arg_1.ActivityId)
                    {
                        this._cell.push(_local_2);
                    };
                };
            }
            else
            {
                for each (_local_3 in this._cell)
                {
                    if (_local_3.parent)
                    {
                        removeChild(_local_3);
                    };
                    if (_local_3.info.ActivityId == _arg_1.ActivityId)
                    {
                        _local_3.info = _arg_1;
                    };
                };
            };
            if (((!(this._askCellVec)) || (this._askCellVec.length == this._cell.length)))
            {
                _local_4 = new Vector.<ActivityItem>();
                _local_5 = new Vector.<ActivityItem>();
                _local_6 = new Vector.<ActivityItem>();
                _local_7 = new Vector.<ActivityItem>();
                this._askCellVec = null;
                if (this._cell.length > 0)
                {
                    for each (_local_9 in this._cell)
                    {
                        if (((ActivityController.instance.checkOpenActivity(_local_9.info)) && (!(ActivityController.instance.checkFinish(_local_9.info)))))
                        {
                            addChild(_local_9);
                            _local_5.push(_local_9);
                        };
                        if ((((!(_local_8)) && (!(ActivityController.instance.model.showID == ""))) && (ActivityController.instance.model.showID == _local_9.info.ActivityId)))
                        {
                            _local_8 = _local_9;
                        };
                    };
                    for each (_local_10 in this._cell)
                    {
                        if (((((!(ActivityController.instance.checkOpenActivity(_local_10.info))) && (!(ActivityController.instance.checkFirstCharge(_local_10.info)))) && (!(ActivityController.instance.checkMouthActivity(_local_10.info)))) && (!(ActivityController.instance.checkFinish(_local_10.info)))))
                        {
                            addChild(_local_10);
                            _local_6.push(_local_10);
                        };
                        if ((((!(_local_8)) && (!(ActivityController.instance.model.showID == ""))) && (ActivityController.instance.model.showID == _local_10.info.ActivityId)))
                        {
                            _local_8 = _local_10;
                        };
                    };
                    if (_local_6.length > 2)
                    {
                        _local_6.sort(this.compareFunction);
                    };
                    for each (_local_11 in this._cell)
                    {
                        if ((((ActivityController.instance.checkMouthActivity(_local_11.info)) && (ActivityController.instance.checkShowCondition(_local_11.info))) && (!(ActivityController.instance.checkFinish(_local_11.info)))))
                        {
                            addChild(_local_11);
                            _local_7.push(_local_11);
                        };
                        if ((((!(_local_8)) && (!(ActivityController.instance.model.showID == ""))) && (ActivityController.instance.model.showID == _local_11.info.ActivityId)))
                        {
                            _local_8 = _local_11;
                        };
                    };
                    _local_12 = _local_5.concat(_local_6);
                    _local_4 = _local_12.concat(_local_7);
                    this._cell = _local_4;
                    if (this._cell.length > 0)
                    {
                        if ((((this._selectedItemNew) && (_arg_1.ActivityId == this._selectedItemNew.info.ActivityId)) && (!(ActivityController.instance.checkFinish(_arg_1)))))
                        {
                            this.setSelectedItemNew(this._selectedItemNew);
                        }
                        else
                        {
                            if ((!(_local_8)))
                            {
                                _local_8 = this._cell[0];
                            };
                            this.setSelectedItemNew(_local_8);
                            ActivityController.instance.setData(_local_8.info);
                        };
                        this._contentHolder.visible = true;
                    }
                    else
                    {
                        ActivityController.instance.setData(null);
                        this._contentHolder.visible = false;
                    };
                }
                else
                {
                    this._contentHolder.visible = false;
                };
            };
        }

        private function compareFunction(_arg_1:ActivityItem, _arg_2:ActivityItem):Number
        {
            if (this.getLevel(_arg_1.info) < this.getLevel(_arg_2.info))
            {
                return (-1);
            };
            if (this.getLevel(_arg_1.info) == this.getLevel(_arg_2.info))
            {
                return (0);
            };
            return (1);
        }

        private function getLevel(_arg_1:ActivityInfo):int
        {
            var _local_2:int;
            switch (_arg_1.ActivityType)
            {
                case ActivityTypes.CHARGE:
                    _local_2 = 1;
                    break;
                case ActivityTypes.COST:
                    _local_2 = 2;
                    break;
                case ActivityTypes.MARRIED:
                    _local_2 = 3;
                    break;
                case ActivityTypes.BEAD:
                case ActivityTypes.PET:
                    _local_2 = 4;
                    break;
                case ActivityTypes.RELEASE:
                    _local_2 = 5;
                    break;
                case ActivityTypes.CONVERT:
                    _local_2 = 6;
                    break;
                default:
                    _local_2 = 7;
            };
            return (_local_2);
        }

        private function isBeforeToday(_arg_1:Date):Boolean
        {
            var _local_2:Date = new Date(_arg_1.fullYear, _arg_1.month, _arg_1.date);
            return (_local_2 <= TimeManager.Instance.Now());
        }

        private function isAfterToday(_arg_1:Date):Boolean
        {
            var _local_2:Date = new Date(_arg_1.fullYear, _arg_1.month, _arg_1.date);
            return (_local_2 > TimeManager.Instance.Now());
        }

        private function configUI():void
        {
            this._contentHolder = ComponentFactory.Instance.creatCustomObject("ddtcalendar.ActivityContentHolder");
        }

        public function setSelectedItemNew(_arg_1:ActivityItem):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            if (_arg_1 != this._selectedItemNew)
            {
                if (this._selectedItemNew)
                {
                    this._selectedItemNew.selected = false;
                };
                this._selectedItemNew = _arg_1;
                this._selectedItemNew.selected = true;
                addChildAt(this._contentHolder, 0);
                _local_2 = this._cell.indexOf(this._selectedItemNew);
                _local_3 = this._cell.length;
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    if (_local_4 <= _local_2)
                    {
                        this._cell[_local_4].y = (_local_4 * 55);
                    }
                    else
                    {
                        this._cell[_local_4].y = (((_local_4 * 55) + this._contentHolder.height) - 53);
                    };
                    _local_4++;
                };
                this._contentHolder.y = (this._selectedItemNew.y + 35);
                dispatchEvent(new Event(MENU_REFRESH));
            };
        }

        private function __cellClick(_arg_1:MouseEvent):void
        {
            var _local_2:ActivityItem = (_arg_1.currentTarget as ActivityItem);
            this.setSelectedItemNew(_local_2);
            ActivityController.instance.setData(_local_2.info);
            SoundManager.instance.play("008");
        }

        override public function get height():Number
        {
            var _local_1:int;
            if (this._cell.length == 1)
            {
                _local_1 = (this._contentHolder.y + this._contentHolder.height);
            }
            else
            {
                if (this._cell.length > 0)
                {
                    _local_1 = (((55 * this._cell.length) + this._contentHolder.height) - 53);
                };
            };
            return (_local_1);
        }

        public function dispose():void
        {
            var _local_1:ActivityItem = this._cell.shift();
            while (_local_1 != null)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1.removeEventListener(MouseEvent.CLICK, this.__cellClick);
                _local_1 = this._cell.shift();
            };
            ObjectUtils.disposeObject(this._contentHolder);
            this._contentHolder = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package activity.view

