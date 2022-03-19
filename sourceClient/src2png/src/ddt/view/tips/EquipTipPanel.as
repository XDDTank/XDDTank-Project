﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.EquipTipPanel

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.tip.ITip;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.PlayerManager;
    import ddt.manager.ItemManager;
    import com.pickgliss.utils.Directions;
    import com.pickgliss.ui.vo.DirectionPos;

    public class EquipTipPanel extends BaseTip implements Disposeable, ITip 
    {

        private var _equipPanel:EquipTipBasePanel;
        private var _myEquipPanel:EquipTipBasePanel;


        override protected function init():void
        {
            super.init();
            this._equipPanel = new EquipTipBasePanel();
            addChild(this._equipPanel);
            this._myEquipPanel = new EquipTipBasePanel(1);
            addChild(this._myEquipPanel);
        }

        override public function get tipData():Object
        {
            return (_tipData);
        }

        private function getCellIndex(_arg_1:EquipmentTemplateInfo):int
        {
            switch (_arg_1.TemplateType)
            {
                case 1:
                    return (10);
                case 2:
                    return (11);
                case 3:
                    return (12);
                case 4:
                    return (13);
                case 6:
                    return (15);
                case 5:
                    return (14);
                case 7:
                    return (16);
                case 8:
                    return (17);
                case 9:
                    return (18);
                case 10:
                    return (19);
                case 11:
                    return (20);
                case 12:
                    return (23);
                case 13:
                    return (22);
                case 14:
                    return (21);
                default:
                    return (-1);
            };
        }

        override public function set tipData(_arg_1:Object):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:EquipmentTemplateInfo;
            _tipData = _arg_1;
            this._equipPanel.tipData = _tipData;
            this._equipPanel.y = 0;
            _width = this._equipPanel.width;
            _height = this._equipPanel.height;
            this._myEquipPanel.visible = false;
            if ((_tipData is InventoryItemInfo))
            {
                _local_2 = (_tipData as InventoryItemInfo);
                if (((!(_local_2.UserID == PlayerManager.Instance.Self.ID)) || (_local_2.Place >= 30)))
                {
                    _local_3 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                    if (PlayerManager.Instance.Self.Bag.items[this.getCellIndex(_local_3)])
                    {
                        this._myEquipPanel.tipData = PlayerManager.Instance.Self.Bag.items[this.getCellIndex(_local_3)];
                        this._myEquipPanel.visible = true;
                        this._myEquipPanel.x = (this._equipPanel.width + 10);
                        this._equipPanel.y = 25;
                        _width = (this._myEquipPanel.x + this._myEquipPanel.width);
                        _height = Math.max(this._myEquipPanel.height, (this._equipPanel.y + this._equipPanel.height));
                        return;
                    };
                };
            };
            _width = ((this._myEquipPanel.visible) ? (this._myEquipPanel.x + this._myEquipPanel.width) : this._equipPanel.width);
            _height = ((this._myEquipPanel.visible) ? Math.max(this._myEquipPanel.height, (this._equipPanel.y + this._equipPanel.height)) : this._equipPanel.height);
        }

        override public function set currentDirectionPos(_arg_1:DirectionPos):void
        {
            super.currentDirectionPos = _arg_1;
            var _local_2:int = Directions.getHorizontalDirection(_currentDirection.direction);
            if (((this._myEquipPanel.visible) && (_local_2 < 0)))
            {
                this._myEquipPanel.x = 0;
                this._equipPanel.x = ((this._myEquipPanel.x + this._myEquipPanel.width) + 10);
            }
            else
            {
                this._equipPanel.x = 0;
                this._myEquipPanel.x = ((this._equipPanel.x + this._equipPanel.width) + 10);
            };
        }


    }
}//package ddt.view.tips
