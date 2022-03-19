// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//auctionHouse.view.AuctionRightView

package auctionHouse.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.ListPanel;
    import ddt.data.auctionHouse.AuctionGoodsInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import ddt.manager.LanguageMgr;
    import auctionHouse.AuctionState;
    import com.pickgliss.events.ListItemEvent;
    import flash.events.MouseEvent;
    import auctionHouse.model.AuctionHouseModel;
    import auctionHouse.event.AuctionHouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SoundManager;
    import __AS3__.vec.*;

    public class AuctionRightView extends Sprite implements Disposeable 
    {

        private var _prePage_btn:BaseButton;
        private var _nextPage_btn:BaseButton;
        private var _first_btn:BaseButton;
        private var _end_btn:BaseButton;
        public var page_txt:FilterFrameText;
        private var _sorttxtItems:Vector.<FilterFrameText>;
        private var _sortBtItems:Vector.<Sprite>;
        private var _sortArrowItems:Vector.<ScaleFrameImage>;
        private var _stripList:ListPanel;
        private var _state:String;
        private var _currentButtonIndex:uint = 0;
        private var _currentIsdown:Boolean = true;
        private var _selectStrip:StripView;
        private var _selectInfo:AuctionGoodsInfo;
        private var help_mc:Bitmap;
        private var _nameTxt:FilterFrameText;
        private var _bidNumberTxt:FilterFrameText;
        private var _RemainingTimeTxt:FilterFrameText;
        private var _SellPersonTxt:FilterFrameText;
        private var _bidpriceTxt:FilterFrameText;
        private var _BidPersonTxt:FilterFrameText;
        private var _tableline:Bitmap;
        private var _tableline1:Bitmap;
        private var _tableline2:Bitmap;
        private var _tableline3:Bitmap;
        private var GoodsName_btn:Sprite;
        private var RemainingTime_btn:Sprite;
        private var SellPerson_btn:Sprite;
        private var BidPrice_btn:Sprite;
        private var BidPerson_btn:Sprite;
        private var index:int = 0;
        private var _startNum:int = 0;
        private var _endNum:int = 0;
        private var _totalCount:int = 0;


        public function setup(_arg_1:String=""):void
        {
            this._state = _arg_1;
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            var _local_8:ScaleFrameImage;
            this._sortBtItems = new Vector.<Sprite>(6);
            this._sorttxtItems = new Vector.<FilterFrameText>(6);
            this._sortArrowItems = new Vector.<ScaleFrameImage>(4);
            var _local_1:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightBG1");
            addChild(_local_1);
            var _local_2:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightItemButtomBG");
            addChild(_local_2);
            var _local_3:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.PageCountBgI");
            addChild(_local_3);
            var _local_4:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("asset.auctionHouse.Browse.PageCountBg");
            addChild(_local_4);
            this.help_mc = ComponentFactory.Instance.creatBitmap("asset.auctionHouse.Help");
            addChild(this.help_mc);
            this._prePage_btn = ComponentFactory.Instance.creat("auctionHouse.Prev_btn");
            addChild(this._prePage_btn);
            this._nextPage_btn = ComponentFactory.Instance.creat("auctionHouse.Next_btn");
            addChild(this._nextPage_btn);
            this._first_btn = ComponentFactory.Instance.creat("auctionHouse.first_btn");
            this._end_btn = ComponentFactory.Instance.creat("auctionHouse.end_btn");
            this.page_txt = ComponentFactory.Instance.creat("auctionHouse.RightPageText");
            addChild(this.page_txt);
            var _local_5:ScaleLeftRightImage = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.RightItemTopBG");
            addChild(_local_5);
            this._nameTxt = ComponentFactory.Instance.creat("ddtauction.nameTxt");
            this._nameTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.name");
            this._bidNumberTxt = ComponentFactory.Instance.creat("ddtauction.bidNumerTxt");
            this._bidNumberTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.number");
            addChild(this._bidNumberTxt);
            this._RemainingTimeTxt = ComponentFactory.Instance.creat("ddtauction.remainingTimeTxt");
            this._RemainingTimeTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.timer");
            this._SellPersonTxt = ComponentFactory.Instance.creat("ddtauction.SellPersonTxt");
            this._SellPersonTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.sellPron");
            this._BidPersonTxt = ComponentFactory.Instance.creat("ddtauction.BidPersonTxt");
            this._BidPersonTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.bidPron");
            this._bidpriceTxt = ComponentFactory.Instance.creat("ddtauction.BidPriceTxt");
            this._bidpriceTxt.text = LanguageMgr.GetTranslation("tank.ddtauctionHouse.text.price");
            this._tableline = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline);
            this._tableline.x = 264;
            this._tableline1 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline1);
            this._tableline1.x = 314;
            this._tableline2 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline2);
            this._tableline2.x = 426;
            this._tableline3 = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            addChild(this._tableline3);
            this._tableline3.x = 517;
            this._tableline.y = (this._tableline1.y = (this._tableline2.y = (this._tableline3.y = 7)));
            this.GoodsName_btn = new Sprite();
            this.GoodsName_btn.graphics.beginFill(0xFFFFFF, 1);
            this.GoodsName_btn.graphics.drawRect(0, 6, 190, 30);
            this.GoodsName_btn.graphics.endFill();
            this.GoodsName_btn.alpha = 0;
            this.GoodsName_btn.buttonMode = true;
            addChild(this.GoodsName_btn);
            this.GoodsName_btn.x = 74;
            this.RemainingTime_btn = new Sprite();
            this.RemainingTime_btn.graphics.beginFill(0xFFFFFF, 1);
            this.RemainingTime_btn.graphics.drawRect(0, 6, 109, 30);
            this.RemainingTime_btn.graphics.endFill();
            this.RemainingTime_btn.alpha = 0;
            this.RemainingTime_btn.buttonMode = true;
            addChild(this.RemainingTime_btn);
            this.RemainingTime_btn.x = 317;
            this.SellPerson_btn = new Sprite();
            this.SellPerson_btn.graphics.beginFill(0xFFFFFF, 1);
            this.SellPerson_btn.graphics.drawRect(0, 6, 88, 30);
            this.SellPerson_btn.graphics.endFill();
            this.SellPerson_btn.alpha = 0;
            this.SellPerson_btn.buttonMode = true;
            addChild(this.SellPerson_btn);
            this.SellPerson_btn.x = 429;
            this.BidPrice_btn = new Sprite();
            this.BidPrice_btn.graphics.beginFill(0xFFFFFF, 1);
            this.BidPrice_btn.graphics.drawRect(0, 6, 173, 30);
            this.BidPrice_btn.graphics.endFill();
            this.BidPrice_btn.alpha = 0;
            this.BidPrice_btn.buttonMode = true;
            addChild(this.BidPrice_btn);
            this.BidPrice_btn.x = 520;
            this.BidPerson_btn = new Sprite();
            this.BidPerson_btn.graphics.beginFill(0xFFFFFF, 1);
            this.BidPerson_btn.graphics.drawRect(0, 6, 88, 30);
            this.BidPerson_btn.graphics.endFill();
            this.BidPerson_btn.alpha = 0;
            this.BidPerson_btn.buttonMode = true;
            this.BidPerson_btn.x = 429;
            addChild(this.BidPerson_btn);
            this._sorttxtItems[0] = this._nameTxt;
            this._sorttxtItems[2] = this._RemainingTimeTxt;
            this._sorttxtItems[3] = this._SellPersonTxt;
            this._sorttxtItems[4] = this._bidpriceTxt;
            this._sorttxtItems[5] = this._BidPersonTxt;
            var _local_6:int;
            while (_local_6 < this._sorttxtItems.length)
            {
                if (_local_6 != 1)
                {
                    if (_local_6 == 3)
                    {
                        if (this._state == AuctionState.BROWSE)
                        {
                            addChild(this._sorttxtItems[_local_6]);
                        };
                    }
                    else
                    {
                        if (_local_6 == 5)
                        {
                            if (this._state == AuctionState.SELL)
                            {
                                addChild(this._sorttxtItems[_local_6]);
                            };
                        }
                        else
                        {
                            addChild(this._sorttxtItems[_local_6]);
                        };
                    };
                };
                _local_6++;
            };
            this._sortBtItems[0] = this.GoodsName_btn;
            this._sortBtItems[2] = this.RemainingTime_btn;
            this._sortBtItems[3] = this.SellPerson_btn;
            this._sortBtItems[4] = this.BidPrice_btn;
            this._sortBtItems[5] = this.BidPerson_btn;
            var _local_7:int;
            while (_local_7 < this._sortBtItems.length)
            {
                if (_local_7 != 1)
                {
                    if (_local_7 == 3)
                    {
                        if (this._state == AuctionState.BROWSE)
                        {
                            addChild(this._sortBtItems[_local_7]);
                        };
                    }
                    else
                    {
                        if (_local_7 == 5)
                        {
                            if (this._state == AuctionState.SELL)
                            {
                                addChild(this._sortBtItems[_local_7]);
                            };
                        }
                        else
                        {
                            addChild(this._sortBtItems[_local_7]);
                        };
                    };
                };
                _local_7++;
            };
            this._sortArrowItems[0] = ComponentFactory.Instance.creat("auctionHouse.ArrowI");
            this._sortArrowItems[1] = ComponentFactory.Instance.creat("auctionHouse.ArrowII");
            this._sortArrowItems[2] = ComponentFactory.Instance.creat("auctionHouse.ArrowIII");
            this._sortArrowItems[3] = ComponentFactory.Instance.creat("auctionHouse.ArrowV");
            for each (_local_8 in this._sortArrowItems)
            {
                addChild(_local_8);
                _local_8.visible = false;
            };
            this._stripList = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.rightListII");
            addChild(this._stripList);
            this._stripList.list.updateListView();
            this._stripList.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            if (this._state == AuctionState.SELL)
            {
                this.help_mc.visible = false;
            };
            this.addStageInit();
            this._nextPage_btn.enable = false;
            this._prePage_btn.enable = false;
            this._first_btn.enable = false;
            this._end_btn.enable = false;
        }

        private function addEvent():void
        {
            var _local_1:int;
            while (_local_1 < this._sortBtItems.length)
            {
                if (_local_1 != 1)
                {
                    this._sortBtItems[_local_1].addEventListener(MouseEvent.CLICK, this.sortHandler);
                };
                _local_1++;
            };
        }

        public function addStageInit():void
        {
        }

        public function hideReady():void
        {
            this._hideArrow();
        }

        public function addAuction(_arg_1:AuctionGoodsInfo):void
        {
            _arg_1.index = this._stripList.vectorListModel.getSize();
            this._stripList.vectorListModel.append(_arg_1);
            this._stripList.list.updateListView();
            this.help_mc.visible = false;
        }

        public function updateAuction(_arg_1:AuctionGoodsInfo):void
        {
            var _local_2:AuctionGoodsInfo;
            var _local_4:AuctionGoodsInfo;
            var _local_3:int;
            for each (_local_4 in this._stripList.vectorListModel.elements)
            {
                if (_local_4.AuctionID == _arg_1.AuctionID)
                {
                    _local_2 = _local_4;
                    break;
                };
            };
            if (_local_2 != null)
            {
                _arg_1.BagItemInfo = _local_2.BagItemInfo;
            };
            if (this._stripList.vectorListModel.indexOf(_local_2) != -1)
            {
                this._stripList.vectorListModel.replaceAt(this._stripList.vectorListModel.indexOf(_local_2), _arg_1);
            }
            else
            {
                this._stripList.vectorListModel.append(_arg_1);
            };
            this._stripList.list.updateListView();
        }

        internal function getStripCount():int
        {
            return (this._stripList.vectorListModel.size());
        }

        internal function setPage(_arg_1:int, _arg_2:int):void
        {
            var _local_3:int;
            _arg_1 = (1 + (AuctionHouseModel.SINGLE_PAGE_NUM * (_arg_1 - 1)));
            if (((_arg_1 + AuctionHouseModel.SINGLE_PAGE_NUM) - 1) < _arg_2)
            {
                _local_3 = ((_arg_1 + AuctionHouseModel.SINGLE_PAGE_NUM) - 1);
            }
            else
            {
                _local_3 = _arg_2;
            };
            this._startNum = _arg_1;
            this._endNum = _local_3;
            this._totalCount = _arg_2;
            if (_arg_2 == 0)
            {
                if (this._stripList.vectorListModel.elements.length == 0)
                {
                    this.page_txt.text = "";
                };
            }
            else
            {
                this.page_txt.text = (((int((this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM)) + 1).toString() + "/") + (int(((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM)) + 1).toString());
            };
            this.buttonStatus(_arg_1, _local_3, _arg_2);
        }

        private function upPageTxt():void
        {
            if (this._endNum < this._startNum)
            {
                this.page_txt.text = "";
            }
            else
            {
                this.page_txt.text = (((int((this._startNum / AuctionHouseModel.SINGLE_PAGE_NUM)) + 1).toString() + "/") + (int(((this._totalCount - 1) / AuctionHouseModel.SINGLE_PAGE_NUM)) + 1).toString());
            };
            if (this._stripList.vectorListModel.elements.length == 0)
            {
                this.page_txt.text = "";
            };
            if (this._endNum < this._totalCount)
            {
                this._nextPage_btn.enable = true;
                this._end_btn.enable = true;
            }
            else
            {
                this._nextPage_btn.enable = false;
                this._end_btn.enable = false;
            };
        }

        private function buttonStatus(_arg_1:int, _arg_2:int, _arg_3:int):void
        {
            if (_arg_1 <= 1)
            {
                this._prePage_btn.enable = false;
                this._first_btn.enable = false;
            }
            else
            {
                this._prePage_btn.enable = true;
                this._first_btn.enable = true;
            };
            if (_arg_2 < _arg_3)
            {
                this._nextPage_btn.enable = true;
                this._end_btn.enable = true;
            }
            else
            {
                this._nextPage_btn.enable = false;
                this._end_btn.enable = false;
            };
            this._nextPage_btn.alpha = 1;
            this._prePage_btn.alpha = 1;
        }

        internal function clearList():void
        {
            this._clearItems();
            this._selectInfo = null;
            this.page_txt.text = "";
            if (this._state == AuctionState.BROWSE)
            {
                this.help_mc.visible = true;
            };
            if (this._stripList.vectorListModel.elements.length == 0)
            {
                this.help_mc.visible = true;
            }
            else
            {
                this.help_mc.visible = false;
            };
            if (this._state == AuctionState.SELL)
            {
                this.help_mc.visible = false;
            };
        }

        private function _clearItems():void
        {
            this._stripList.vectorListModel.clear();
            this._stripList.list.updateListView();
        }

        private function invalidatePanel():void
        {
        }

        internal function getSelectInfo():AuctionGoodsInfo
        {
            if (this._selectInfo)
            {
                return (this._selectInfo);
            };
            return (null);
        }

        internal function deleteItem():void
        {
            var _local_1:AuctionGoodsInfo;
            for each (_local_1 in this._stripList.vectorListModel.elements)
            {
                if (_local_1.AuctioneerID == this._selectInfo.AuctioneerID)
                {
                    this._stripList.vectorListModel.remove(_local_1);
                    this._selectInfo = null;
                    this.upPageTxt();
                    break;
                };
            };
            this._stripList.list.updateListView();
        }

        internal function clearSelectStrip():void
        {
            this._stripList.vectorListModel.remove(this._selectInfo);
            this._selectInfo = null;
            this.upPageTxt();
            this._stripList.list.unSelectedAll();
            this._stripList.list.updateListView();
        }

        internal function setSelectEmpty():void
        {
            this._selectStrip.isSelect = false;
            this._selectStrip = null;
            this._selectInfo = null;
        }

        internal function get sortCondition():int
        {
            return (this._currentButtonIndex);
        }

        internal function get sortBy():Boolean
        {
            return (this._currentIsdown);
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            var _local_2:StripView = (_arg_1.cell as StripView);
            this._selectStrip = _local_2;
            this._selectInfo = _local_2.info;
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SELECT_STRIP));
        }

        private function removeEvent():void
        {
            var _local_1:int;
            while (_local_1 < this._sortBtItems.length)
            {
                if (_local_1 != 1)
                {
                    this._sortBtItems[_local_1].removeEventListener(MouseEvent.CLICK, this.sortHandler);
                    ObjectUtils.disposeObject(this._sortBtItems[_local_1]);
                };
                _local_1++;
            };
            this._sortBtItems = null;
        }

        private function sortHandler(_arg_1:MouseEvent):void
        {
            AuctionHouseModel._dimBooble = false;
            SoundManager.instance.play("047");
            var _local_2:uint = this._sortBtItems.indexOf((_arg_1.target as Sprite));
            if (this._currentButtonIndex == _local_2)
            {
                this.changeArrow(_local_2, (!(this._currentIsdown)));
            }
            else
            {
                this.changeArrow(_local_2, true);
            };
        }

        private function _showOneArrow(_arg_1:uint):void
        {
            this._hideArrow();
            this._sortArrowItems[_arg_1].visible = true;
        }

        private function _hideArrow():void
        {
            var _local_1:ScaleFrameImage;
            for each (_local_1 in this._sortArrowItems)
            {
                _local_1.visible = false;
            };
        }

        private function changeArrow(_arg_1:uint, _arg_2:Boolean):void
        {
            var _local_3:uint = _arg_1;
            if (_arg_1 == 5)
            {
                _arg_1 = 3;
            };
            _arg_1 = ((_arg_1 == 0) ? 0 : (_arg_1 - 1));
            this._showOneArrow(_arg_1);
            if (_arg_2)
            {
                this._sortArrowItems[_arg_1].setFrame(2);
            }
            else
            {
                this._sortArrowItems[_arg_1].setFrame(1);
            };
            this._currentIsdown = _arg_2;
            this._currentButtonIndex = _local_3;
            AuctionHouseModel.searchType = 3;
            if (this._stripList.vectorListModel.elements.length < 1)
            {
                return;
            };
            dispatchEvent(new AuctionHouseEvent(AuctionHouseEvent.SORT_CHANGE));
        }

        public function get prePage_btn():BaseButton
        {
            return (this._prePage_btn);
        }

        public function get nextPage_btn():BaseButton
        {
            return (this._nextPage_btn);
        }

        public function dispose():void
        {
            var _local_1:ScaleFrameImage;
            this.removeEvent();
            this._selectInfo = null;
            if (this._first_btn)
            {
                ObjectUtils.disposeObject(this._first_btn);
            };
            this._first_btn = null;
            if (this._end_btn)
            {
                ObjectUtils.disposeObject(this._end_btn);
            };
            this._end_btn = null;
            if (this._prePage_btn)
            {
                ObjectUtils.disposeObject(this._prePage_btn);
            };
            this._prePage_btn = null;
            if (this._nextPage_btn)
            {
                ObjectUtils.disposeObject(this._nextPage_btn);
            };
            this._nextPage_btn = null;
            if (this.page_txt)
            {
                ObjectUtils.disposeObject(this.page_txt);
            };
            this.page_txt = null;
            for each (_local_1 in this._sortArrowItems)
            {
                ObjectUtils.disposeObject(_local_1);
            };
            this._sortArrowItems = null;
            if (this._selectStrip)
            {
                ObjectUtils.disposeObject(this._selectStrip);
            };
            this._selectStrip = null;
            this._stripList.vectorListModel.clear();
            if (this._stripList)
            {
                this._stripList.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
                ObjectUtils.disposeObject(this._stripList);
            };
            this._stripList = null;
            if (this.help_mc)
            {
                ObjectUtils.disposeObject(this.help_mc);
            };
            this.help_mc = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package auctionHouse.view

