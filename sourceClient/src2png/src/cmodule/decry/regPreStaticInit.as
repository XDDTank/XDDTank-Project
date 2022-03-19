// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.regPreStaticInit

package cmodule.decry
{
    public function regPreStaticInit(_arg_1:Function):void
    {
        if ((!(gpreStaticInits)))
        {
            gpreStaticInits = [];
        };
        gpreStaticInits.push(_arg_1);
    }

}//package cmodule.decry

