// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityNum

package activity.view
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityNum extends MovieClip 
    {

        public static const COST:String = "Cost";
        public static const CHARGE:String = "Charge";
        public static const CHARGE_ONCE:String = "ChargeOnce";

        public var num1_cost:MovieClip;
        public var num2_cost:MovieClip;
        public var num3_cost:MovieClip;
        public var num4_cost:MovieClip;
        public var num5_cost:MovieClip;
        public var num6_cost:MovieClip;
        public var num7_cost:MovieClip;
        public var num1_charge:MovieClip;
        public var num2_charge:MovieClip;
        public var num3_charge:MovieClip;
        public var num4_charge:MovieClip;
        public var num5_charge:MovieClip;
        public var num6_charge:MovieClip;
        public var num7_charge:MovieClip;
        private var _num_1:MovieClip = new MovieClip();
        private var _num_2:MovieClip = new MovieClip();
        private var _num_3:MovieClip = new MovieClip();
        private var _num_4:MovieClip = new MovieClip();
        private var _num_5:MovieClip = new MovieClip();
        private var _num_6:MovieClip = new MovieClip();
        private var _num_7:MovieClip = new MovieClip();
        private var _type:String;
        private var NUM_DIR:int = 20;
        private var _point:Point = new Point(57, 2);


        public function set type(_arg_1:String):void
        {
            this._type = _arg_1;
            this._point = ComponentFactory.Instance.creatCustomObject(("ddtactivity.ActivityNum.pos" + this._type));
            PositionUtils.setPos(this, this._point);
            switch (this._type)
            {
                case COST:
                    this._num_1 = this.num1_cost;
                    this._num_2 = this.num2_cost;
                    this._num_3 = this.num3_cost;
                    this._num_4 = this.num4_cost;
                    this._num_5 = this.num5_cost;
                    this._num_6 = this.num6_cost;
                    this._num_7 = this.num7_cost;
                    break;
                case CHARGE:
                case CHARGE_ONCE:
                    this._num_1 = this.num1_charge;
                    this._num_2 = this.num2_charge;
                    this._num_3 = this.num3_charge;
                    this._num_4 = this.num4_charge;
                    this._num_5 = this.num5_charge;
                    this._num_6 = this.num6_charge;
                    this._num_7 = this.num7_charge;
                    break;
            };
            this.num1_cost.visible = (this._type == COST);
            this.num2_cost.visible = (this._type == COST);
            this.num3_cost.visible = (this._type == COST);
            this.num4_cost.visible = (this._type == COST);
            this.num5_cost.visible = (this._type == COST);
            this.num6_cost.visible = (this._type == COST);
            this.num7_cost.visible = (this._type == COST);
            this.num1_charge.visible = (this._type == CHARGE);
            this.num2_charge.visible = (this._type == CHARGE);
            this.num3_charge.visible = (this._type == CHARGE);
            this.num4_charge.visible = (this._type == CHARGE);
            this.num5_charge.visible = (this._type == CHARGE);
            this.num6_charge.visible = (this._type == CHARGE);
            this.num7_charge.visible = (this._type == CHARGE);
        }

        public function setNum(_arg_1:int):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_7:int;
            _arg_1 = Math.abs(_arg_1);
            _local_2 = int((_arg_1 / 1000000));
            _local_3 = int((((_arg_1 % 10000000) % 1000000) / 100000));
            _local_4 = int(((((_arg_1 % 10000000) % 1000000) % 100000) / 10000));
            var _local_5:int = int((((((_arg_1 % 10000000) % 1000000) % 100000) % 10000) / 1000));
            var _local_6:int = int(((((((_arg_1 % 10000000) % 1000000) % 100000) % 10000) % 1000) / 100));
            _local_7 = int((((((((_arg_1 % 10000000) % 1000000) % 100000) % 10000) % 1000) % 100) / 10));
            var _local_8:int = (((((((_arg_1 % 10000000) % 1000000) % 100000) % 10000) % 1000) % 100) % 10);
            this._num_1.visible = true;
            this._num_2.visible = true;
            this._num_3.visible = true;
            this._num_4.visible = true;
            this._num_5.visible = true;
            this._num_6.visible = true;
            this._num_7.visible = true;
            if (_local_2 != 0)
            {
                x = this._point.x;
                this._num_1.gotoAndStop((_local_2 + 1));
                this._num_2.gotoAndStop((_local_3 + 1));
                this._num_3.gotoAndStop((_local_4 + 1));
                this._num_4.gotoAndStop((_local_5 + 1));
                this._num_5.gotoAndStop((_local_6 + 1));
                this._num_6.gotoAndStop((_local_7 + 1));
            }
            else
            {
                this._num_1.visible = false;
                x = (this._point.x - this.NUM_DIR);
                if (_local_3 != 0)
                {
                    this._num_2.gotoAndStop((_local_3 + 1));
                    this._num_3.gotoAndStop((_local_4 + 1));
                    this._num_4.gotoAndStop((_local_5 + 1));
                    this._num_5.gotoAndStop((_local_6 + 1));
                    this._num_6.gotoAndStop((_local_7 + 1));
                }
                else
                {
                    this._num_2.visible = false;
                    x = (x - this.NUM_DIR);
                    if (_local_4 != 0)
                    {
                        this._num_3.gotoAndStop((_local_4 + 1));
                        this._num_4.gotoAndStop((_local_5 + 1));
                        this._num_5.gotoAndStop((_local_6 + 1));
                        this._num_6.gotoAndStop((_local_7 + 1));
                    }
                    else
                    {
                        this._num_3.visible = false;
                        x = (x - this.NUM_DIR);
                        if (_local_5 != 0)
                        {
                            this._num_4.gotoAndStop((_local_5 + 1));
                            this._num_5.gotoAndStop((_local_6 + 1));
                            this._num_6.gotoAndStop((_local_7 + 1));
                        }
                        else
                        {
                            this._num_4.visible = false;
                            if (_local_6 != 0)
                            {
                                this._num_5.gotoAndStop((_local_6 + 1));
                                this._num_6.gotoAndStop((_local_7 + 1));
                            }
                            else
                            {
                                this._num_5.visible = false;
                                if (_local_7 != 0)
                                {
                                    this._num_6.gotoAndStop((_local_7 + 1));
                                }
                                else
                                {
                                    this._num_6.visible = false;
                                    x = (x - this.NUM_DIR);
                                };
                            };
                        };
                    };
                };
            };
            this._num_7.gotoAndStop((_local_8 + 1));
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._num_1);
            this._num_1 = null;
            ObjectUtils.disposeObject(this._num_2);
            this._num_2 = null;
            ObjectUtils.disposeObject(this._num_3);
            this._num_3 = null;
            ObjectUtils.disposeObject(this._num_4);
            this._num_4 = null;
            ObjectUtils.disposeObject(this._num_5);
            this._num_5 = null;
            ObjectUtils.disposeObject(this._num_6);
            this._num_5 = null;
            ObjectUtils.disposeObject(this._num_7);
            this._num_5 = null;
        }


    }
}//package activity.view

