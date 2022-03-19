// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//liveness.DailyReceiveItem

package liveness
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.TextButton;
    import __AS3__.vec.Vector;
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.controls.container.HBox;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class DailyReceiveItem extends Sprite implements Disposeable 
    {

        private var _index:int;
        private var _bg:Scale9CornerImage;
        private var _dayTitleBg:Bitmap;
        private var _day:ScaleFrameImage;
        private var _line:ScaleBitmapImage;
        private var _already:Bitmap;
        private var _receiveBtn:TextButton;
        private var _itemCell:Vector.<BaseCell>;
        private var _itemCellHbox:HBox;

        public function DailyReceiveItem(_arg_1:int)
        {
            this._index = _arg_1;
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("liveness.frame.dailyReceiveItem.bg");
            this._line = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyLine");
            this._already = ComponentFactory.Instance.creatBitmap("ddt.dailyReceive.already");
            this._already.visible = false;
            this._dayTitleBg = ComponentFactory.Instance.creatBitmap("ddt.dailyReceive.dayBg");
            this._day = ComponentFactory.Instance.creatComponentByStylename("liveness.frame.dailyReceiveItem.day");
            this._day.setFrame(this._index);
            this._receiveBtn = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.receiveBtn");
            this._receiveBtn.text = LanguageMgr.GetTranslation("ddthall.dailyReceive.receiveTxt");
            this._itemCellHbox = ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.itemCellBox");
            addChild(this._bg);
            addChild(this._line);
            addChild(this._dayTitleBg);
            addChild(this._day);
            addChild(this._receiveBtn);
            addChild(this._already);
            addChild(this._itemCellHbox);
            this.initCell();
            this.updateView();
        }

        private function initEvent():void
        {
            this._receiveBtn.addEventListener(MouseEvent.CLICK, this.__receiveHandler);
        }

        private function removeEvent():void
        {
            this._receiveBtn.removeEventListener(MouseEvent.CLICK, this.__receiveHandler);
        }

        private function __receiveHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendDailyReceive(PlayerManager.Instance.Self.awardLog);
        }

        private function initCell():void
        {
            var _local_4:BaseCell;
            var _local_5:InventoryItemInfo;
            this._itemCell = new Vector.<BaseCell>();
            var _local_1:Array = DailyReceiveManager.Instance.getByDayTemplateId(this._index);
            var _local_2:Array = DailyReceiveManager.Instance.getByGradeAwards(_local_1);
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                _local_4 = new BaseCell(ComponentFactory.Instance.creatComponentByStylename("ddthall.dailyReceive.itemCellBg"));
                _local_5 = new InventoryItemInfo();
                _local_5.TemplateID = _local_2[_local_3].TemplateID;
                _local_5.Count = _local_2[_local_3].Count;
                _local_5.IsBinds = _local_2[_local_3].IsBinds;
                ItemManager.fill(_local_5);
                _local_4.isShowCount = true;
                _local_4.info = _local_5;
                _local_4.setContentSize(40, 40);
                _local_4.picPos = new Point(4, 4);
                this._itemCell.push(_local_4);
                this._itemCellHbox.addChild(_local_4);
                _local_3++;
            };
        }

        private function updateCell():void
        {
            var _local_1:int;
            while (_local_1 < this._itemCell.length)
            {
                this._itemCell[_local_1].alpha = 0.5;
                _local_1++;
            };
        }

        private function updateView():void
        {
            if (this._index < PlayerManager.Instance.Self.awardLog)
            {
                this._receiveBtn.visible = false;
                this._already.visible = true;
                this.updateCell();
            }
            else
            {
                if (this._index > PlayerManager.Instance.Self.awardLog)
                {
                    this._receiveBtn.visible = true;
                    this._receiveBtn.enable = false;
                    this._already.visible = false;
                }
                else
                {
                    if (PlayerManager.Instance.Self.isAward)
                    {
                        this._receiveBtn.visible = false;
                        this._already.visible = true;
                        this.updateCell();
                    }
                    else
                    {
                        this._receiveBtn.visible = true;
                        this._receiveBtn.enable = true;
                        this._already.visible = false;
                    };
                };
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._line)
            {
                ObjectUtils.disposeObject(this._line);
            };
            this._line = null;
            if (this._already)
            {
                ObjectUtils.disposeObject(this._already);
            };
            this._already = null;
            if (this._dayTitleBg)
            {
                ObjectUtils.disposeObject(this._dayTitleBg);
            };
            this._dayTitleBg = null;
            if (this._day)
            {
                ObjectUtils.disposeObject(this._day);
            };
            this._day = null;
            if (this._receiveBtn)
            {
                ObjectUtils.disposeObject(this._receiveBtn);
            };
            this._receiveBtn = null;
            if (this._itemCellHbox)
            {
                ObjectUtils.disposeObject(this._itemCellHbox);
            };
            this._itemCellHbox = null;
        }


    }
}//package liveness

