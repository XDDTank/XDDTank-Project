// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityCell

package activity.view
{
    import bagAndInfo.cell.BaseCell;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import activity.data.ActivityRewardInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityCell extends BaseCell 
    {

        private var _getIcon:Bitmap;
        private var _giftBagPic:Bitmap;
        private var _showItem:Boolean;
        private var _count:FilterFrameText;
        private var _euipQualityBg:ScaleFrameImage;
        private var _rewardInfo:ActivityRewardInfo;

        public function ActivityCell(_arg_1:ActivityRewardInfo, _arg_2:Boolean=true, _arg_3:Bitmap=null)
        {
            var _local_4:InventoryItemInfo;
            var _local_5:ItemTemplateInfo;
            this._showItem = _arg_2;
            if (_arg_1)
            {
                this._rewardInfo = _arg_1;
                _local_4 = new InventoryItemInfo();
                _local_5 = ItemManager.Instance.getTemplateById(int(this._rewardInfo.TemplateId));
                _local_4.TemplateID = int(this._rewardInfo.TemplateId);
                _local_4.ValidDate = this._rewardInfo.ValidDate;
                _local_4.IsBinds = this._rewardInfo.IsBind;
                ItemManager.fill(_local_4);
                _local_4.StrengthenLevel = this._rewardInfo.getProperty()[0];
                _local_4.Attack = _local_5.Attack;
                _local_4.Defence = _local_5.Defence;
                _local_4.Agility = _local_5.Agility;
                _local_4.Luck = _local_5.Luck;
                _info = _local_4;
            };
            if ((_arg_3 == null))
            {
                _bg = ComponentFactory.Instance.creatBitmap("ddtcalendar.exchange.cellBg");
            }
            else
            {
                _bg = _arg_3;
            };
            super(_bg, _info);
            this._giftBagPic = ComponentFactory.Instance.creatBitmap("asset.ActivityCell.giftbag.pic");
            addChild(this._giftBagPic);
            this._getIcon = ComponentFactory.Instance.creatBitmap("asset.ActivityCell.getIcon");
            this._getIcon.visible = false;
            addChild(this._getIcon);
            this._count = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCell.count");
            this._count.text = "0";
            addChild(this._count);
            this.setType();
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            super.info = _arg_1;
            if (info == null)
            {
                _local_2 = null;
                this.initeuipQualityBg(0);
            };
            if (info != null)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
            };
            if (((!(_local_2 == null)) && (info.Property8 == "0")))
            {
                this.initeuipQualityBg(_local_2.QualityID);
            }
            else
            {
                this.initeuipQualityBg(0);
            };
        }

        public function showBg(_arg_1:Boolean):void
        {
            _bg.visible = _arg_1;
        }

        public function showCount(_arg_1:Boolean):void
        {
            this._count.visible = _arg_1;
        }

        private function initeuipQualityBg(_arg_1:int):void
        {
            if (this._euipQualityBg == null)
            {
                this._euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
                PositionUtils.setPos(this._euipQualityBg, "ddtactivity.ActivityCell.qualityBg.pos");
                this._euipQualityBg.width = 43;
                this._euipQualityBg.height = 43;
            };
            if (_arg_1 == 0)
            {
                this._euipQualityBg.visible = false;
            }
            else
            {
                if (_arg_1 == 1)
                {
                    addChildAt(this._euipQualityBg, 1);
                    this._euipQualityBg.setFrame(_arg_1);
                    this._euipQualityBg.visible = true;
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        addChildAt(this._euipQualityBg, 1);
                        this._euipQualityBg.setFrame(_arg_1);
                        this._euipQualityBg.visible = true;
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            addChildAt(this._euipQualityBg, 1);
                            this._euipQualityBg.setFrame(_arg_1);
                            this._euipQualityBg.visible = true;
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                addChildAt(this._euipQualityBg, 1);
                                this._euipQualityBg.setFrame(_arg_1);
                                this._euipQualityBg.visible = true;
                            }
                            else
                            {
                                if (_arg_1 == 5)
                                {
                                    addChildAt(this._euipQualityBg, 1);
                                    this._euipQualityBg.setFrame(_arg_1);
                                    this._euipQualityBg.visible = true;
                                };
                            };
                        };
                    };
                };
            };
        }

        public function set count(_arg_1:int):void
        {
            this._count.text = _arg_1.toString();
        }

        public function setType():void
        {
            if (this._showItem)
            {
                _pic.visible = true;
                _bg.visible = true;
                this._count.visible = true;
                this._giftBagPic.visible = false;
            }
            else
            {
                _pic.visible = false;
                _bg.visible = false;
                this._count.visible = false;
                this._giftBagPic.visible = true;
            };
        }

        public function set canGet(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._giftBagPic.filters = null;
                _pic.filters = null;
            }
            else
            {
                this._giftBagPic.filters = ComponentFactory.Instance.creatFilters("grayFilter");
                _pic.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            };
        }

        public function set hasGet(_arg_1:Boolean):void
        {
            this._getIcon.visible = _arg_1;
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._giftBagPic);
            this._giftBagPic = null;
            ObjectUtils.disposeObject(this._getIcon);
            this._getIcon = null;
            ObjectUtils.disposeObject(this._count);
            this._count = null;
            ObjectUtils.disposeObject(this._euipQualityBg);
            this._euipQualityBg = null;
            super.dispose();
        }


    }
}//package activity.view

