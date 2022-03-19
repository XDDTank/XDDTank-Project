// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.view.ComposeItemCell

package store.view.Compose.view
{
    import store.StoreCell;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import flash.events.MouseEvent;
    import bagAndInfo.cell.DragEffect;

    public class ComposeItemCell extends StoreCell 
    {

        public function ComposeItemCell(_arg_1:int)
        {
            var _local_2:Sprite = new Sprite();
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EquipCellBG");
            _local_2.addChild(_local_3);
            super(_local_2, _arg_1);
            setContentSize(68, 68);
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:ItemTemplateInfo;
            var _local_3:InventoryItemInfo;
            if (_arg_1)
            {
                _local_2 = ItemManager.Instance.getTemplateById(_arg_1.TemplateID);
                _local_3 = new InventoryItemInfo();
                _local_3.TemplateID = _local_2.TemplateID;
                ItemManager.fill(_local_3);
                _local_3.IsBinds = true;
                super.info = _local_3;
                _tbxCount.visible = false;
            }
            else
            {
                super.info = _arg_1;
            };
        }

        override public function seteuipQualityBg(_arg_1:int):void
        {
            if (_euipQualityBg == null)
            {
                _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
                _euipQualityBg.width = 68;
                _euipQualityBg.height = 68;
                _euipQualityBg.x = -3;
                _euipQualityBg.y = -3;
            };
            if (_arg_1 == 0)
            {
                _euipQualityBg.visible = false;
            }
            else
            {
                if (_arg_1 == 1)
                {
                    addChildAt(_euipQualityBg, 1);
                    _euipQualityBg.setFrame(_arg_1);
                    _euipQualityBg.visible = true;
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        addChildAt(_euipQualityBg, 1);
                        _euipQualityBg.setFrame(_arg_1);
                        _euipQualityBg.visible = true;
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            addChildAt(_euipQualityBg, 1);
                            _euipQualityBg.setFrame(_arg_1);
                            _euipQualityBg.visible = true;
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                addChildAt(_euipQualityBg, 1);
                                _euipQualityBg.setFrame(_arg_1);
                                _euipQualityBg.visible = true;
                            }
                            else
                            {
                                if (_arg_1 == 5)
                                {
                                    addChildAt(_euipQualityBg, 1);
                                    _euipQualityBg.setFrame(_arg_1);
                                    _euipQualityBg.visible = true;
                                };
                            };
                        };
                    };
                };
            };
        }

        override protected function initEvent():void
        {
            addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
            addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
        }

        override public function dragStart():void
        {
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package store.view.Compose.view

