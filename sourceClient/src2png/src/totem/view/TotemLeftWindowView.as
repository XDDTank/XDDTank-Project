// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemLeftWindowView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import __AS3__.vec.Vector;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import totem.data.TotemDataVo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.ui.LayerManager;
    import totem.TotemManager;
    import ddt.manager.TaskManager;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SocketManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import __AS3__.vec.*;

    public class TotemLeftWindowView extends Sprite implements Disposeable 
    {

        private var _bg:Bitmap;
        private var _bgList:Vector.<Bitmap>;
        private var _totemPointSprite:Sprite;
        private var _totemPointList:Vector.<TotemLeftWindowTotemCell>;
        private var _curCanClickPointLocation:int;
        private var _totemPointLocationList:Array = [[{
            "x":94,
            "y":62
        }, {
            "x":164,
            "y":258
        }, {
            "x":269,
            "y":111
        }, {
            "x":365,
            "y":251
        }, {
            "x":506,
            "y":189
        }, {
            "x":663,
            "y":252
        }, {
            "x":606,
            "y":86
        }], [{
            "x":57,
            "y":247
        }, {
            "x":139,
            "y":63
        }, {
            "x":269,
            "y":184
        }, {
            "x":433,
            "y":97
        }, {
            "x":622,
            "y":59
        }, {
            "x":669,
            "y":233
        }, {
            "x":434,
            "y":278
        }], [{
            "x":71,
            "y":197
        }, {
            "x":176,
            "y":34
        }, {
            "x":390,
            "y":74
        }, {
            "x":245,
            "y":247
        }, {
            "x":403,
            "y":204
        }, {
            "x":524,
            "y":271
        }, {
            "x":646,
            "y":137
        }], [{
            "x":100,
            "y":182
        }, {
            "x":234,
            "y":80
        }, {
            "x":291,
            "y":265
        }, {
            "x":425,
            "y":124
        }, {
            "x":535,
            "y":281
        }, {
            "x":564,
            "y":122
        }, {
            "x":686,
            "y":67
        }], [{
            "x":87,
            "y":27
        }, {
            "x":120,
            "y":265
        }, {
            "x":384,
            "y":277
        }, {
            "x":596,
            "y":216
        }, {
            "x":676,
            "y":62
        }, {
            "x":489,
            "y":118
        }, {
            "x":313,
            "y":68
        }]];
        private var _propertyTxtSprite:TotemLeftWindowPropertyTxtView;
        private var _tipView:TotemPointTipView;
        private var _routeMCs:Vector.<MovieClip>;
        private var _rountMCPoints:Vector.<Point>;
        private var _changePageFun:Function;
        private var _nextTotemInfo:TotemDataVo;
        private var openProcess:int = 0;
        private var _failTotemInfo:TotemDataVo;
        private var _currentPage:int;
        private var _openCount:int = 0;
        private var _nextPointInfo:TotemDataVo;
        private var _flowFrameCount:int = 0;
        private var _tmpLocation:int;

        public function TotemLeftWindowView()
        {
            this.init();
        }

        private function init():void
        {
            var _local_1:int;
            this._routeMCs = new Vector.<MovieClip>();
            this._rountMCPoints = new Vector.<Point>();
            this._bgList = new Vector.<Bitmap>();
            _local_1 = 1;
            while (_local_1 <= 5)
            {
                this._bgList.push(ComponentFactory.Instance.creatBitmap(("asset.totem.leftView.windowBg" + _local_1)));
                _local_1++;
            };
            _local_1 = 1;
            while (_local_1 <= 5)
            {
                this._rountMCPoints.push(ComponentFactory.Instance.creatCustomObject(("totem.flowpoint" + _local_1)));
                this._routeMCs.push(addChild(ClassUtils.CreatInstance(("asset.totem.flow" + _local_1))));
                DisplayUtils.setDisplayPos(this._routeMCs[(_local_1 - 1)], this._rountMCPoints[(_local_1 - 1)]);
                _local_1++;
            };
            this._propertyTxtSprite = new TotemLeftWindowPropertyTxtView();
            this._tipView = new TotemPointTipView();
            this._tipView.visible = false;
            LayerManager.Instance.addToLayer(this._tipView, LayerManager.GAME_TOP_LAYER);
        }

        public function refreshView(_arg_1:TotemDataVo, _arg_2:Function=null):void
        {
            this._tipView.visible = false;
            if ((!(TotemManager.instance.isLast)))
            {
                this.refreshTotemPoint(_arg_1.Page, _arg_1, true);
            }
            else
            {
                this._changePageFun = _arg_2;
                this._nextTotemInfo = _arg_1;
                this.doLastLightFun();
            };
            TaskManager.instance.checkHighLight();
        }

        private function doLastLightFun():void
        {
            TotemManager.instance.isLast = false;
            if ((!(this._nextTotemInfo)))
            {
                this.doLastOpen(5);
                return;
            };
            this.doLastOpen(this._nextTotemInfo.Page);
            addEventListener(Event.ENTER_FRAME, this.__onOpenTotemProcess);
        }

        private function __onOpenTotemProcess(_arg_1:Event):void
        {
            var _local_2:int;
            this.openProcess++;
            if (this.openProcess > 45)
            {
                this.refreshTotemPoint(this._nextTotemInfo.Page, this._nextTotemInfo, true);
                if (this._changePageFun != null)
                {
                    this._changePageFun.apply();
                };
                this._routeMCs[(this._nextTotemInfo.Page - 1)].gotoAndPlay("stand2");
                this._totemPointList[0].isCurCanClick = true;
                this._totemPointList[0].isHasLighted = false;
                _local_2 = 1;
                while (_local_2 < 7)
                {
                    this._totemPointList[_local_2].isCurCanClick = false;
                    this._totemPointList[_local_2].isHasLighted = false;
                    _local_2++;
                };
                removeEventListener(Event.ENTER_FRAME, this.__onOpenTotemProcess);
                this.openProcess = 0;
            };
        }

        private function doLastOpen(_arg_1:int=1):void
        {
            this._totemPointList[6].isCurCanClick = false;
            this._totemPointList[6].doLightTotem();
            var _local_2:int = TotemManager.instance.getCurrentLv(TotemManager.instance.getTotemPointLevel(PlayerManager.Instance.Self.totemId));
            this._propertyTxtSprite.refreshLayer(_local_2, this._nextTotemInfo, _arg_1);
        }

        public function openFailHandler(_arg_1:TotemDataVo):void
        {
            this._failTotemInfo = _arg_1;
            this._totemPointList[(_arg_1.Location - 1)].showOpenFail();
            TotemManager.instance.addEventListener(TotemLeftWindowTotemCell.OPEN_TOTEM_FAIL, this.__onFailMCcomplete);
        }

        private function __onFailMCcomplete(_arg_1:Event):void
        {
            this.refreshTotemPoint(this._failTotemInfo.Page, this._failTotemInfo, true);
        }

        private function enableCurCanClickBtn():void
        {
            if (((!(this._curCanClickPointLocation == 0)) && (this._totemPointList)))
            {
                this._totemPointList[(this._curCanClickPointLocation - 1)].mouseChildren = true;
                this._totemPointList[(this._curCanClickPointLocation - 1)].mouseEnabled = true;
            };
        }

        private function disenableCurCanClickBtn():void
        {
            if (((!(this._curCanClickPointLocation == 0)) && (this._totemPointList)))
            {
                this._totemPointList[(this._curCanClickPointLocation - 1)].mouseChildren = false;
                this._totemPointList[(this._curCanClickPointLocation - 1)].mouseEnabled = false;
            };
        }

        public function show(_arg_1:int, _arg_2:TotemDataVo, _arg_3:Boolean):void
        {
            this.openProcess = 0;
            this._openCount = 0;
            this._flowFrameCount = 0;
            removeEventListener(Event.ENTER_FRAME, this.__onFlowStart);
            removeEventListener(Event.ENTER_FRAME, this.__onOpenTotemProcess);
            removeEventListener(Event.ENTER_FRAME, this.__onOpenComplete);
            if (_arg_1 == 0)
            {
                _arg_1 = 1;
            };
            if (this._bg)
            {
                removeChild(this._bg);
            };
            this._bg = this._bgList[(_arg_1 - 1)];
            addChildAt(this._bg, 0);
            var _local_4:int = 1;
            while (_local_4 <= 5)
            {
                if (_arg_1 == _local_4)
                {
                    this._routeMCs[(_local_4 - 1)].visible = true;
                }
                else
                {
                    this._routeMCs[(_local_4 - 1)].visible = false;
                };
                _local_4++;
            };
            this.addTotemPoint(this._totemPointLocationList[(_arg_1 - 1)], _arg_1, _arg_2, _arg_3);
            addChild(this._propertyTxtSprite);
        }

        private function addTotemPoint(_arg_1:Array, _arg_2:int, _arg_3:TotemDataVo, _arg_4:Boolean):void
        {
            var _local_6:int;
            var _local_7:TotemLeftWindowTotemCell;
            var _local_8:TotemLeftWindowTotemCell;
            if (this._totemPointSprite)
            {
                if (((!(this._curCanClickPointLocation == 0)) && (this._totemPointList)))
                {
                    this._totemPointList[(this._curCanClickPointLocation - 1)].useHandCursor = false;
                    this._totemPointList[(this._curCanClickPointLocation - 1)].removeEventListener(MouseEvent.CLICK, this.openTotem);
                    this._totemPointList[(this._curCanClickPointLocation - 1)].removeEventListener(MouseEvent.MOUSE_OVER, this.showTip);
                    this._totemPointList[(this._curCanClickPointLocation - 1)].removeEventListener(MouseEvent.MOUSE_OUT, this.hideTip);
                    this._curCanClickPointLocation = 0;
                };
                if (this._totemPointSprite.parent)
                {
                    this._totemPointSprite.parent.removeChild(this._totemPointSprite);
                };
                this._totemPointSprite = null;
            };
            if (this._totemPointList)
            {
                for each (_local_7 in this._totemPointList)
                {
                    _local_7.removeEventListener(MouseEvent.MOUSE_OVER, this.showTip);
                    _local_7.removeEventListener(MouseEvent.MOUSE_OUT, this.hideTip);
                    ObjectUtils.disposeObject(_local_7);
                };
                this._totemPointList = null;
            };
            this._totemPointSprite = new Sprite();
            this._totemPointList = new Vector.<TotemLeftWindowTotemCell>();
            var _local_5:int = _arg_1.length;
            _local_6 = 0;
            while (_local_6 < _local_5)
            {
                _local_8 = new TotemLeftWindowTotemCell(_arg_2);
                _local_8.x = _arg_1[_local_6].x;
                _local_8.y = _arg_1[_local_6].y;
                _local_8.addEventListener(MouseEvent.MOUSE_OVER, this.showTip, false, 0, true);
                _local_8.addEventListener(MouseEvent.MOUSE_OUT, this.hideTip, false, 0, true);
                _local_8.index = (_local_6 + 1);
                _local_8.isCurCanClick = false;
                this._totemPointSprite.addChild(_local_8);
                this._totemPointList.push(_local_8);
                _local_6++;
            };
            this._propertyTxtSprite.show(_arg_1, _arg_3, _arg_2);
            this.refreshGlowFilter(_arg_2, _arg_3);
            this.refreshTotemPoint(_arg_2, _arg_3, _arg_4);
            addChild(this._totemPointSprite);
        }

        private function refreshGlowFilter(_arg_1:int, _arg_2:TotemDataVo):void
        {
            var _local_3:int;
            var _local_4:int = this._totemPointList.length;
            _local_3 = 0;
            while (_local_3 < _local_4)
            {
                if ((((!(_arg_2)) || (_arg_1 < _arg_2.Page)) || ((_local_3 + 1) < _arg_2.Location)))
                {
                    if ((!(TotemManager.instance.isUpgrade)))
                    {
                        this._totemPointList[_local_3].isHasLighted = true;
                    }
                    else
                    {
                        this._totemPointList[_local_3].doLightTotem();
                    };
                }
                else
                {
                    this._totemPointList[_local_3].isHasLighted = false;
                };
                _local_3++;
            };
        }

        private function refreshTotemPoint(_arg_1:int, _arg_2:TotemDataVo, _arg_3:Boolean):void
        {
            var _local_4:int;
            var _local_7:int;
            if (((_arg_2) && (_arg_1 == _arg_2.Page)))
            {
                if (((TotemManager.instance.isUpgrade) && (!(_arg_2.Location == 1))))
                {
                    this._currentPage = _arg_1;
                    this._nextPointInfo = _arg_2;
                    addEventListener(Event.ENTER_FRAME, this.__onFlowStart);
                }
                else
                {
                    if (((this._routeMCs) && (!(_arg_2.Location == 7))))
                    {
                        this._routeMCs[(_arg_1 - 1)].gotoAndPlay((("stand" + (_arg_2.Location + 1)) + "1"));
                    }
                    else
                    {
                        this._routeMCs[(_arg_1 - 1)].gotoAndStop("stand9");
                    };
                };
            }
            else
            {
                this._routeMCs[(_arg_1 - 1)].gotoAndStop("stand9");
            };
            if (this._curCanClickPointLocation != 0)
            {
                _local_7 = (this._curCanClickPointLocation - 1);
                this._totemPointList[_local_7].removeEventListener(MouseEvent.CLICK, this.openTotem);
                this._totemPointList[_local_7].useHandCursor = false;
                this._totemPointList[_local_7].buttonMode = false;
                this._totemPointList[_local_7].mouseChildren = true;
                this._totemPointList[_local_7].mouseEnabled = true;
                this._totemPointList[_local_7].isCurCanClick = false;
                if ((!(TotemManager.instance.isUpgrade)))
                {
                    this._totemPointList[_local_7].isHasLighted = true;
                    TotemManager.instance.isUpgrade = false;
                }
                else
                {
                    this._totemPointList[_local_7].doLightTotem();
                };
                this._curCanClickPointLocation = 0;
            };
            if ((((_arg_3) && (_arg_2)) && (_arg_1 == _arg_2.Page)))
            {
                this._tmpLocation = (_arg_2.Location - 1);
                this._curCanClickPointLocation = _arg_2.Location;
                if (((!(TotemManager.instance.isUpgrade)) || (_arg_2.Location == 1)))
                {
                    this.setTotemClickable(this._tmpLocation);
                };
            };
            if (((!(_arg_2)) || (_arg_1 < _arg_2.Page)))
            {
                _local_4 = (_arg_1 * 10);
            }
            else
            {
                _local_4 = (((_arg_1 - 1) * 10) + _arg_2.Layers);
            };
            this._propertyTxtSprite.refreshLayer(_local_4, _arg_2, _arg_1);
            var _local_5:int = this._totemPointList.length;
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                this._totemPointList[_local_6].level = _local_4;
                _local_6++;
            };
            if (_arg_1 == 1)
            {
                this.showUserGuilde();
            };
        }

        private function __onFlowStart(_arg_1:Event):void
        {
            this._openCount++;
            if (this._openCount >= 35)
            {
                this._routeMCs[(this._currentPage - 1)].gotoAndPlay(("stand" + (this._nextPointInfo.Location + 1)));
                removeEventListener(Event.ENTER_FRAME, this.__onFlowStart);
                this._openCount = 0;
                addEventListener(Event.ENTER_FRAME, this.__onOpenComplete);
            };
        }

        private function setTotemClickable(_arg_1:int):void
        {
            this._totemPointList[this._tmpLocation].useHandCursor = true;
            this._totemPointList[this._tmpLocation].buttonMode = true;
            this._totemPointList[this._tmpLocation].mouseChildren = true;
            this._totemPointList[this._tmpLocation].mouseEnabled = true;
            this._totemPointList[this._tmpLocation].addEventListener(MouseEvent.CLICK, this.openTotem, false, 0, true);
            this._totemPointList[this._tmpLocation].isCurCanClick = true;
        }

        private function __onOpenComplete(_arg_1:Event):void
        {
            this._flowFrameCount++;
            if (this._flowFrameCount >= 20)
            {
                this.setTotemClickable(this._tmpLocation);
                removeEventListener(Event.ENTER_FRAME, this.__onOpenComplete);
                this._flowFrameCount = 0;
            };
        }

        public function scalePropertyTxtSprite(_arg_1:Number):void
        {
            if (this._propertyTxtSprite)
            {
                this._propertyTxtSprite.scaleTxt(_arg_1);
            };
        }

        private function openTotem(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:TotemDataVo = TotemManager.instance.getNextInfoById(PlayerManager.Instance.Self.totemId);
            if (((PlayerManager.Instance.Self.totemScores < _local_2.ConsumeHonor) || (TotemManager.instance.usableGP < _local_2.ConsumeExp)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.honorOrExpUnenough"));
                return;
            };
            if (PlayerManager.Instance.Self.Grade < _local_2.needGrade)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.totem.needGrade", _local_2.needGrade));
                return;
            };
            this.disenableCurCanClickBtn();
            SocketManager.Instance.out.sendOpenOneTotem();
        }

        private function showTip(_arg_1:MouseEvent):void
        {
            var _local_2:TotemLeftWindowTotemCell;
            var _local_3:Point;
            _local_2 = (_arg_1.currentTarget as TotemLeftWindowTotemCell);
            if ((!(_local_2.isCurCanClick)))
            {
                return;
            };
            _local_3 = this.localToGlobal(new Point(((_local_2.x + (_local_2.width / 2)) + 30), (_local_2.y - 30)));
            this._tipView.x = _local_3.x;
            this._tipView.y = _local_3.y;
            var _local_4:TotemDataVo = TotemManager.instance.getCurInfoByLevel((((_local_2.level - 1) * 7) + _local_2.index));
            this._tipView.show(_local_4, _local_2.isCurCanClick, _local_2.isHasLighted);
            this._tipView.visible = true;
        }

        private function hideTip(_arg_1:MouseEvent):void
        {
            this._tipView.visible = false;
        }

        public function showUserGuilde():void
        {
            if ((((!(SavePointManager.Instance.savePoints[69])) && (!(TaskManager.instance.isCompleted(TaskManager.instance.getQuestByID(593))))) && (TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(592)))))
            {
                if (this._curCanClickPointLocation == 1)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, -90, "trainer.totemClick1", "", "", this);
                };
                if (this._curCanClickPointLocation == 2)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, -135, "trainer.totemClick2", "", "", this);
                };
                if (this._curCanClickPointLocation == 3)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, 0, "trainer.totemClick3", "", "", this);
                };
                if (this._curCanClickPointLocation == 4)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, -90, "trainer.totemClick4", "", "", this);
                };
                if (this._curCanClickPointLocation == 5)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, 0, "trainer.totemClick5", "", "", this);
                };
                if (this._curCanClickPointLocation == 6)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, -90, "trainer.totemClick6", "", "", this);
                };
                if (this._curCanClickPointLocation == 7)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_TOTEM, -90, "trainer.totemClick7", "", "", this);
                };
            }
            else
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_TOTEM);
            };
        }

        public function dispose():void
        {
            var _local_1:TotemLeftWindowTotemCell;
            removeEventListener(Event.ENTER_FRAME, this.__onFlowStart);
            removeEventListener(Event.ENTER_FRAME, this.__onOpenTotemProcess);
            removeEventListener(Event.ENTER_FRAME, this.__onOpenComplete);
            TotemManager.instance.removeEventListener(TotemLeftWindowTotemCell.OPEN_TOTEM_FAIL, this.__onFailMCcomplete);
            if (((!(this._curCanClickPointLocation == 0)) && (this._totemPointList)))
            {
                this._totemPointList[(this._curCanClickPointLocation - 1)].useHandCursor = false;
                this._totemPointList[(this._curCanClickPointLocation - 1)].removeEventListener(MouseEvent.CLICK, this.openTotem);
                this._curCanClickPointLocation = 0;
            };
            if (this._totemPointList)
            {
                for each (_local_1 in this._totemPointList)
                {
                    _local_1.removeEventListener(MouseEvent.MOUSE_OVER, this.showTip);
                    _local_1.removeEventListener(MouseEvent.MOUSE_OUT, this.hideTip);
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            ObjectUtils.disposeAllChildren(this);
            this._totemPointSprite = null;
            this._totemPointList = null;
            this._bg = null;
            this._bgList = null;
            this._propertyTxtSprite = null;
            this._routeMCs = null;
            ObjectUtils.disposeObject(this._tipView);
            this._tipView = null;
            TotemManager.instance.isUpgrade = false;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

