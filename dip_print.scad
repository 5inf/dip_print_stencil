/*  This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <https://www.gnu.org/licenses/>.
*/

/*
An OpenSCAD script for generating 3D models of stencils for the ERSA Dip&Print Station 0PR100.

Variable names and their descriptions are according to the documents provided on the website of "Kurtz Holding GmbH & Co. Beteiligungs KG", https://www.kurtzersa.com/.
The corresponding documents are linked below, both in their German and English version.

The values and function of the Stencils are not yet tested. Especially the bga and flat_* modules will not yet produce valid stencils. Improvements and bugfixes are welcome.
*/


//Maßangaben Dip-Schablone / Dimensional properties for Dip-Stencils
//https://www.kurtzersa.de/fileadmin/medien/members_final/Electronics/1_Technische_Datenblaetter/1.2_Rework/Massangaben_fuer_Dip_Print_Schablonen_-_Dip.pdf
//https://www.kurtzersa.com/fileadmin/medien/members_final/Electronics/1_Technische_Datenblaetter/1.2_Rework/Dimensional_properties_for_Dip_Print_stencils_-_Dip_Stencil.pdf
A = 15; //Taschenbreite in X /  Pocket width in X 
B = 20; //Taschenbreite in Y / Pocket width in Y 
_A = 8;
_B = 13;
L = 1; //Eckenradius / Corner radius
_L = 2;
V = 0.2; //Taschentiefe / Pocket depth 

//Maßangaben Print-Schablonen mit Bauteiltasche /  Dimensional properties for Print-Stencils with component pocket
//https://www.kurtzersa.de/fileadmin/medien/members_final/Electronics/1_Technische_Datenblaetter/1.2_Rework/Massangaben_fuer_Dip_Print_Schablonen_-_Print_mit_Bauteiltasche.pdf
C=15;//Taschenbreite in X /  Pocket width in X 
D=20;//Taschenbreite in Y /  Pocket width in Y
E=1;//Eckenradius / Corner radius 
W=1;//Taschentiefe /  Pocket depth 
T=1;//Pastendruckhöhe / Stencil thickness 
f=14;//Mittenabstand äußere Öffnungen in X / Center-to-center distance outer apertures in X 
g=19;//Mittenabstand äußere Öffnungen in Y /  Center-to-center distance outer apertures in Y 
x=0.2; //Öffnungsbreite /  Aperture width 
y=1; //Öffnungslänge /  Aperture length 
p=.635; //Öffnungsraster / Aperture pitch 
h=0.07; //Eckenradius außen /  Outer corner radius 
i=0.07; //Eckenradius innen /  Inner corner radius 
j=1; // Massepad in X /  Ground plane in X 
k=1; //Massepad in Y /  Ground plane in Y 
m=1; //Flächenanteil der Öffnungen relativ zum Pad / Area ratio of the apertures relative to pad 
n=3; // Öffnung in X  /  Aperture in X 
o=3; //  Öffnung in Y /  Aperture in Y
q=4; // Öffnungsraster in X / Aperture pitch in X 
s=4; //  Öffnungsraster in Y / Aperture pitch in Y
r=0.1; // Eckenradius /  Corner radius 
t=3; // Anzahl Öffnungen in X / Amount apertures X 
u=4; //  Anzahl Öffnungen in Y / Amount apertures Y

//Maßangaben für Print-Schablonen für BGAs (ohne Bauteiltasche) / Dimensional properties for Print-Stencils for BGA (without pocket)
//https://www.kurtzersa.de/fileadmin/medien/members_final/Electronics/1_Technische_Datenblaetter/1.2_Rework/Massangaben_fuer_Dip_Print_Schablonen_-_Print_ohne_Bauteiltasche.pdf
//https://www.kurtzersa.com/fileadmin/medien/members_final/Electronics/1_Technische_Datenblaetter/1.2_Rework/Dimensional_properties_for_Dip_Print_stencils_-_Print_Stencil_without_pocket.pdf
d=0.5;//Öffnungsdurchmesser / Aperture diameter 
z=2;// Öffnungsraster /  Aperture pitch 
v=10;// Anzahl Öffnungen in X /  Amount of apertures X 
w=10;// Anzahl Öffnungen in Y /  Amount of apertures Y 
a=4;// Anzahl freier Zeilen / Amount of free rows 
b=4;// Anzahl freier Spalten / Amount of free columns 
T=2;// Schablonendicke / Stencil thickness 

translate([-50,-50,0]){dip(A=A, B=B, L=L, V=V);}
translate([-150,-50,0]){dip_hollow(A=A, B=B, _A=_A, _B=_B, L=L, _L=_L, V=V);}
translate([-50,50,0]){bga(d=d, z=z, T=T, v=v, w=w, a=a, b=b);}translate([50,-50,0]){
    flat_detailed(C=C,D=D,E=E,T=T,W=W,f=f,g=g,x=x,y=y,p=p,h=h,i=i,n=n,o=o,q=q,s=s,r=r,t=t,u=u);
    }
translate([50,50,0]){flat_simple(C=C,D=D,E=E,T=T,W=W,f=f,g=g,x=x,y=y,p=p,h=h,i=i,j=j,k=k,m=m);}


//this generates the base stencil accordign to
//https://www.kurtzersa.de/fileadmin/medien/members_final/Electronics/1_Technische_Datenblaetter/1.2_Rework/SK234-40_size_of_print_stencil.pdf
module base(height=1){
    linear_extrude(height){
        minkowski(){
            radius=5;
            circle(radius);
            square(76-2*radius,center=true);
        }
    }
    //cube([76,76,1], center=true);
}


module flat_simple(C,D,E=1,T=0.12,W=0.5,f,g,x,y,p,h=0.07,i=0.07,j,k,m){
    //n,o,q,s,r,t,u=f(j,k,m);
    r=0.07;
    flat_detailed(C,D,E,T,W,f,g,x,y,p,h,i,n,o,q,s,r,t,u);
}


module flat_detailed (C,D,E=1,T=0.12,W=0.5,f,g,x,y,p,h=0.07,i=0.07,n,o,q,s,r=0.07,t,u){
    $fs=0.2;
    difference(){
        base(T+W);
        translate([0,0,T]){//part 1 large area
            linear_extrude(W){
                union(){
                    translate([-C/2,-D/2,0])circle(E);
                    translate([-C/2,D/2,0])circle(E);
                    translate([C/2,-D/2,0])circle(E);
                    translate([C/2,D/2,0])circle(E);
                    square([C,D],center=true); 
                }
            }
        }//eof part 1
        translate([0,0,0]){//part 2 pinholes
            linear_extrude(T){
                union(){
                    for(nx=[-(f-1)/2:(f-1)/2]){
                translate([nx*p,g/2,0]){
                                    minkowski(){
                                        circle(h);
                                        square([x-2*h,y-2*h],center=true);
                                    }
                                }
                                translate([nx*p,-g/2,0]){
                                    minkowski(){
                                        circle(h);
                                        square([x-2*h,y-2*h],center=true);
                                    }
                                }
                            }
                            for(ny=[-(g-1)/2:(g-1)/2]){
                translate([f/2,ny*p,0]){
                                    minkowski(){
                                        circle(h);
                                        square([y-2*h,x-2*h],center=true);
                                    }
                                }
                                translate([-f/2,ny*p,0]){
                                    minkowski(){
                                        circle(h);
                                        square([y-2*h,x-2*h],center=true);
                                    }
                                }
                            }
                        }
            }
        }//eof part2
        translate([0,0,0]){//part 3 padholes
            linear_extrude(T){
                 union(){
                    for(nx=[-(t-1)/2:(t-1)/2]){
                        for(ny=[-(u-1)/2:(u-1)/2]){
                            //echo(nx, ny);
                            {
                                translate([nx*q,ny*s,-T]){
                                    minkowski(){
                                        circle(r);
                                        square([n-2*r,o-2*r],center=true);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }//eof part 3
    } 
}



module dip(A, B, L, V){
    $fs=0.2;
    difference(){
        base();
        translate([0,0,1-V]){
        linear_extrude(2*T){
            union(){
               minkowski(){
                radius=L;
                circle(radius);
                square([A-2*radius,B-2*radius],center=true);
                }     
            }
        }
        }
    }
}

module dip_hollow(A, _A, B, _B, L, _L, V){
    $fs=0.2;
    difference(){
        base();
        translate([0,0,1-V]){
        linear_extrude(2*T){
            difference(){
                union(){
                   minkowski(){
                    radius=L;
                    circle(radius);
                    square([A-2*radius,B-2*radius],center=true);
                    }     
                }
                union(){
                   minkowski(){
                    radius=_L;
                    circle(radius);
                    square([_A-2*radius,_B-2*radius],center=true);
                    }     
                }
            }
          }
        }
    }
}



module bga(d, z, T, v, w, a, b){
    $fs=0.2;
    difference(){
        base(T);
        linear_extrude(2*T){
            union(){
                for(nx=[-(v-1)/2:(v-1)/2]){
                    for(ny=[-(w-1)/2:(w-1)/2]){
                        //echo(nx, ny);
                        if(!(((nx>-a/2)&&(nx<a/2))&&((ny>-b/2)&&(ny<b/2)))){
                            translate([nx*z,ny*z,-T]){circle(d);
                        }
                        }
                    }
                }
            }
        }
    }
}

