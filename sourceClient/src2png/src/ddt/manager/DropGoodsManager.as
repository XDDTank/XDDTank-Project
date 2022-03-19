// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.DropGoodsManager

package ddt.manager
{
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import com.pickgliss.toplevel.StageReferance;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Sprite;
    import flash.utils.setTimeout;
    import ddt.data.EquipType;
    import bagAndInfo.BagAndInfoManager;
    import flash.utils.setInterval;
    import flash.display.DisplayObject;
    import ddt.data.goods.EquipmentTemplateInfo;
    import game.view.GetGoodsTipView;
    import turnplate.TurnPlateController;
    import com.pickgliss.utils.ObjectUtils;
    import flash.utils.clearTimeout;
    import ddt.data.TweenVars;
    import com.greensock.TimelineLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Sine;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.MovieClip;
    import flash.utils.clearInterval;
    import __AS3__.vec.*;

    public class DropGoodsManager implements Disposeable 
    {

        public var parentContainer:DisplayObjectContainer;
        public var beginPoint:Point;
        public var endPoint:Point;
        private var goodsList:Vector.<ItemTemplateInfo>;
        private var timeOutIdArr:Array;
        private var tweenArr:Array;
        private var intervalId:uint;
        private var goodsTipList:Vector.<ItemTemplateInfo>;
        private var _info:InventoryItemInfo;

        public function DropGoodsManager(_arg_1:Point, _arg_2:Point)
        {
            this.parentContainer = StageReferance.stage;
            this.beginPoint = _arg_1;
            this.endPoint = _arg_2;
            this.goodsList = new Vector.<ItemTemplateInfo>();
            this.goodsTipList = new Vector.<ItemTemplateInfo>();
            this.timeOutIdArr = new Array();
            this.tweenArr = new Array();
        }

        public static function play(_arg_1:Array, _arg_2:Point=null, _arg_3:Point=null):void
        {
            var _local_6:ItemTemplateInfo;
            var _local_7:BaseCell;
            var _local_8:uint;
            if (_arg_2 == null)
            {
                _arg_2 = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.beginPoint");
            };
            if (_arg_3 == null)
            {
                _arg_3 = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.bagPoint");
            };
            var _local_4:DropGoodsManager = new DropGoodsManager(_arg_2, _arg_3);
            _local_4.setGoodsList(_arg_1);
            var _local_5:int;
            while (_local_5 < _local_4.goodsList.length)
            {
                _local_6 = _local_4.goodsList[_local_5];
                _local_7 = new BaseCell(new Sprite(), _local_6);
                _local_7.setContentSize(48, 48);
                _local_8 = setTimeout(_local_4.packUp, (200 + (_local_5 * 200)), _local_7, _local_4.onCompletePackUp);
                _local_4.timeOutIdArr.push(_local_8);
                if (SavePointManager.Instance.savePoints[64])
                {
                    if ((((_local_6.CategoryID == 40) || (EquipType.isPackage(_local_6))) || (EquipType.canBeUsed(_local_6))))
                    {
                        _local_4.goodsTipList.push(_local_6);
                    };
                };
                _local_5++;
            };
            if (BagAndInfoManager.Instance.IsClose)
            {
                _local_4.intervalId = setInterval(_local_4.showGetGoodTip, 2000);
            };
        }

        public static function petPlay(_arg_1:DisplayObject):void
        {
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("dropGoodsManager.beginPoint");
            var _local_3:Point = ComponentFactory.Instance.creat("dropGoodsManager.petPoint");
            var _local_4:DropGoodsManager = new DropGoodsManager(_local_2, _local_3);
            _local_4.packUp(_arg_1, _local_4.onPetCompletePackUp);
        }

        public static function showTipByTemplateID(_arg_1:int):void
        {
            var _local_4:Boolean;
            var _local_5:EquipmentTemplateInfo;
            var _local_6:GetGoodsTipView;
            if (TurnPlateController.Instance.isShow)
            {
                return;
            };
            var _local_2:Array = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(_arg_1);
            var _local_3:InventoryItemInfo = _local_2[0];
            if (_local_3)
            {
                _local_4 = false;
                if (_local_3.CategoryID == 40)
                {
                    _local_5 = ItemManager.Instance.getEquipTemplateById(_local_3.TemplateID);
                    if (_local_5.TemplateType != EquipType.EMBED_TYPE)
                    {
                        _local_4 = true;
                    };
                }
                else
                {
                    if (EquipType.isPackage(_local_3))
                    {
                        _local_4 = true;
                    }
                    else
                    {
                        if (EquipType.canBeUsed(_local_3))
                        {
                            _local_4 = true;
                        }
                        else
                        {
                            if ((!(EquipType.isPetsEgg(_local_3))))
                            {
                                _local_4 = true;
                            };
                        };
                    };
                };
                if (_local_4)
                {
                    _local_6 = ComponentFactory.Instance.creatComponentByStylename("trainer.view.GetGoodsTip");
                    _local_6.item = _local_3;
                    _local_6.show();
                };
            };
        }


        private function onPetCompletePackUp(_arg_1:DisplayObject):void
        {
            ObjectUtils.disposeObject(_arg_1);
            this.dispose();
        }

        private function packUp(_arg_1:DisplayObject, _arg_2:Function):void
        {
            clearTimeout(this.timeOutIdArr.shift());
            _arg_1.x = this.beginPoint.x;
            _arg_1.y = this.beginPoint.y;
            _arg_1.alpha = 0.5;
            _arg_1.scaleX = 0.85;
            _arg_1.scaleY = 0.85;
            this.parentContainer.addChild(_arg_1);
            var _local_3:Point = this.endPoint;
            var _local_4:Point = new Point((this.beginPoint.x - ((this.beginPoint.x - _local_3.x) / 2)), (this.beginPoint.y - 100));
            var _local_5:Point = new Point((_local_4.x - ((_local_4.x - this.beginPoint.x) / 2)), (this.beginPoint.y - 60));
            var _local_6:Point = new Point((_local_3.x - ((_local_3.x - _local_4.x) / 2)), (this.beginPoint.y + 30));
            var _local_7:TweenVars = (ComponentFactory.Instance.creatCustomObject("dropGoodsManager.tweenVars1") as TweenVars);
            var _local_8:TweenVars = (ComponentFactory.Instance.creatCustomObject("dropGoodsManager.tweenVars2") as TweenVars);
            var _local_9:TimelineLite = new TimelineLite();
            _local_9.append(TweenMax.to(_arg_1, _local_7.duration, {
                "alpha":_local_7.alpha,
                "scaleX":_local_7.scaleX,
                "scaleY":_local_7.scaleY,
                "bezierThrough":[{
                    "x":_local_5.x,
                    "y":_local_5.y
                }, {
                    "x":_local_4.x,
                    "y":_local_4.y
                }],
                "ease":Sine.easeInOut
            }));
            _local_9.append(TweenMax.to(_arg_1, _local_8.duration, {
                "alpha":_local_8.alpha,
                "scaleX":_local_8.scaleX,
                "scaleY":_local_8.scaleY,
                "bezierThrough":[{
                    "x":_local_6.x,
                    "y":_local_6.y
                }, {
                    "x":_local_3.x,
                    "y":_local_3.y
                }],
                "ease":Sine.easeInOut,
                "onComplete":_arg_2,
                "onCompleteParams":[_arg_1]
            }));
            this.tweenArr.push(_local_9);
        }

        private function onCompletePackUp(_arg_1:DisplayObject):void
        {
            if (((_arg_1) && (this.parentContainer.contains(_arg_1))))
            {
                ObjectUtils.disposeObject(_arg_1);
                _arg_1 = null;
            };
            var _local_2:MovieClipWrapper = this.getBagAniam();
            if (_local_2.movie)
            {
                this.parentContainer.addChild(_local_2.movie);
            };
            SoundManager.instance.play("171");
            if (this.tweenArr.length > 0)
            {
                this.tweenArr.shift().clear();
            }
            else
            {
                this.dispose();
            };
        }

        private function getBagAniam():MovieClipWrapper
        {
            var _local_2:Point;
            var _local_1:MovieClip = (ClassUtils.CreatInstance("asset.game.bagAniam") as MovieClip);
            _local_2 = ComponentFactory.Instance.creatCustomObject("dropGoods.bagPoint");
            _local_1.x = _local_2.x;
            _local_1.y = _local_2.y;
            return (new MovieClipWrapper(_local_1, true, true));
        }

        private function setGoodsList(_arg_1:Array):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Object;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_2:Array = new Array();
            _local_3 = 0;
            _loop_1:
            for (;_local_3 < _arg_1.length;_local_3++)
            {
                _local_4 = 0;
                while (_local_4 < this.goodsList.length)
                {
                    if (_arg_1[_local_3].TemplateID == this.goodsList[_local_4].TemplateID) continue _loop_1;
                    _local_4++;
                };
                if ((((_arg_1[_local_3].TemplateID == EquipType.GOLD) || (_arg_1[_local_3].TemplateID == EquipType.STRENGTH_STONE1)) || (_arg_1[_local_3].TemplateID == EquipType.STRENGTH_STONE_NEW)))
                {
                    _local_7 = ((Math.random() * 2) + 2);
                    _local_4 = 0;
                    while (_local_4 < _local_7)
                    {
                        this.goodsList.push(_arg_1[_local_3]);
                        _local_4++;
                    };
                }
                else
                {
                    _local_5 = 0;
                    _local_6 = new Object();
                    _local_4 = 0;
                    while (_local_4 < _arg_1.length)
                    {
                        if (_arg_1[_local_3].TemplateID == _arg_1[_local_4].TemplateID)
                        {
                            _local_5++;
                        };
                        _local_4++;
                    };
                    _local_6.item = _arg_1[_local_3];
                    _local_6.count = _local_5;
                    _local_2.push(_local_6);
                };
            };
            if (_local_2.length > 7)
            {
                _local_3 = 0;
                while (((_local_3 < _local_2.length) && (_local_3 < 10)))
                {
                    this.goodsList.push(_local_2[_local_3].item);
                    _local_3++;
                };
            }
            else
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _local_8 = _local_2[_local_3].count;
                    if (_local_8 == 1)
                    {
                        this.goodsList.push(_local_2[_local_3].item);
                    }
                    else
                    {
                        if (((_local_8 > 1) && (_local_8 <= 3)))
                        {
                            _local_7 = ((Math.random() * 2) + 2);
                            _local_9 = 0;
                            while (_local_9 < _local_7)
                            {
                                this.goodsList.push(_local_2[_local_3].item);
                                _local_9++;
                            };
                        }
                        else
                        {
                            if (_local_8 > 3)
                            {
                                _local_7 = ((Math.random() * 3) + 2);
                                _local_9 = 0;
                                while (_local_9 < _local_7)
                                {
                                    this.goodsList.push(_local_2[_local_3].item);
                                    _local_9++;
                                };
                            };
                        };
                    };
                    _local_3++;
                };
            };
        }

        private function showGetGoodTip():void
        {
            var _local_1:ItemTemplateInfo = this.goodsTipList.pop();
            if (_local_1 == null)
            {
                clearInterval(this.intervalId);
            }
            else
            {
                showTipByTemplateID(_local_1.TemplateID);
            };
        }

        public function dispose():void
        {
            this.parentContainer = null;
            this.beginPoint = null;
            this.endPoint = null;
            this.goodsList = null;
            this.timeOutIdArr = null;
            while (this.tweenArr.length > 0)
            {
                this.tweenArr.shift().clear();
            };
            this.tweenArr = null;
            this.goodsTipList = null;
            this._info = null;
        }


    }
}//package ddt.manager

