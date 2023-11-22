$fn=4;			
fn=32;			

Size		= 25.4;	
slices 		= 80;	
beta_offset 	= 132;	
gamma_offset 	= 99;	
radius_min 	= 0.10;	
radius_mult 	= 0.45;	

d_alpha 	= 360/slices;		echo(str("d_alpha=",d_alpha));
alpha	= [	for(k=[0:slices])	k*d_alpha-180	];
beta	= [	for(k=[0:slices])	(alpha[k] + beta_offset) % 360	];
gamma	= [	for(k=[0:slices])	(alpha[k] + gamma_offset) % 360	];
Radius	= [	for(k=[0:slices])	radius_min*pow(0.5+0.5*cos(gamma[k]),0.25) + radius_mult*pow(0.5+0.5*cos(beta[k]),6) ];
CenterZ	= [	for(k=[0:slices])	cos(alpha[k])	];
CenterY = [	for(k=[0:slices])	sin(alpha[k])*-0.8*pow(0.5+0.5*cos(alpha[k]),3)	];
CenterX	= [	for(k=[0:slices])	0	];
Centers	= [	for(k=[0:slices])	[CenterX[k],CenterY[k],CenterZ[k]]	];
dZ	= [	for(k=[0:slices-1])	CenterZ[k+1] - CenterZ[k]	,	CenterZ[0] - CenterZ[slices]	];
dY	= [	for(k=[0:slices-1])	CenterY[k+1] - CenterY[k]	,	CenterY[0] - CenterY[slices]	];
dX	= [	for(k=[0:slices-1])	CenterX[k+1] - CenterX[k]	,	CenterX[0] - CenterX[slices]	];
Circle	= [	for(j=[0:fn])		let(a=90+j*360/fn)	[ cos(a), sin(a), 0 ]	];

	klein_cygnet();
module	klein_cygnet()
{
    points=
    [
	for(k=[0:slices-1])
	for(j=[0:fn-1])
	let(
		theta0 = -90+atan2(dZ[k],dY[k])
	,	rotate0 =
		[[	1	, 0		,0		]
		,[	0	, cos(theta0)	,-sin(theta0)	]
		,[	0	, sin(theta0)	, cos(theta0)	]]
	,	Point0 	= Centers[k]*Size
			+ rotate0*(Radius[k]*Size*Circle[j])
	)
	Point0
    ];
    facets=
    [
	for(k=[0:slices-1])
	for(j=[0:fn-1])
	let(	Point0 	= k		*fn+	j
	,	Point0p	= k		*fn+	(j+1)%fn
	,	Point1p	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j-1)%fn : (j+1)%fn)
	,	Point1 	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j  )%fn : j)
	)
	[	Point0,Point1,Point1p,Point0p	]
    ];
	color("white")
	polyhedron(points,facets);

    PointsE=
    [
	for(k=[0:slices-1])
	for(j=[0:fn-1])
	let(
		theta0 = -90+atan2(dZ[k],dY[k])
	,	rotate0 =
		[[	1	, 0		,0		]
		,[	0	, cos(theta0)	,-sin(theta0)	]
		,[	0	, sin(theta0)	, cos(theta0)	]]
	,	Point0 	= Centers[k]*Size
			+ rotate0*(Radius[k]*Size*1.03*Circle[j])
	)
	Point0
    ];
    Eyes=
    [
	for(k=[50])
	for(j=[0.25*fn,0.75*fn+1])
	let(	Point0 	= k		*fn+	j
	,	Point1p	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j-1)%fn : (j+1)%fn)
	,	Point1m	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j+1)%fn : (j-1+fn)%fn)
	,	Point2 	= ((k+2)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j  )%fn : j)
	)
	[	Point0,Point1p,Point2,Point1m	]
    ];
	color("black")	polyhedron(PointsE,Eyes);

    PointsB=
    [
	for(k=[0:slices-1])
	for(j=[0:fn-1])
	let(
		theta0 = -90+atan2(dZ[k],dY[k])
	,	rotate0 =
		[[	1	, 0		,0		]
		,[	0	, cos(theta0)	,-sin(theta0)	]
		,[	0	, sin(theta0)	, cos(theta0)	]]
	,	Point0 	= Centers[k]*Size
			+ rotate0*(Radius[k]*Size*1.02*Circle[j])
	)
	Point0
    ];
    Beak=
    [
	for(k=[50+1:56])
	for(j=[0:fn-1])
	if(	0.00*fn<=j && j<=0.25*fn && k>=50+0.25*fn-j	&& k%2==j%2
	||	0.25*fn<=j && j<=0.50*fn && k>=50-0.25*fn+j	&& k%2==j%2
	||	0.50*fn<=j && j<=0.75*fn && k>=50+0.75*fn-j+1	&& k%2==(j+1)%2
	||	0.75*fn<=j && j<=1.00*fn && k>=50-0.75*fn+j-1	&& k%2==(j+1)%2
	)
	let(	Point0 	= k		*fn+	j
	,	Point1p	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j-1)%fn : (j+1)%fn)
	,	Point1m	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j+1)%fn : (j-1+fn)%fn)
	,	Point2 	= ((k+2)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j  )%fn : j)
	)
	[	Point0,Point1p,Point2,Point1m	]
    ];
	color("orange")	polyhedron(PointsB,Beak);

    //	feathers
	for(k=[0:50-1])
	for(j=[k%2:2:fn-1])
	let(	Point0 	= k		*fn+	j
	,	Point0p	= k		*fn+	(j+1)%fn
	,	Point1p	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j-1)%fn : (j+1)%fn)
	,	Point1 	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j  )%fn : j)
	,	Point1m	= ((k+1)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j+1)%fn : (j-1+fn)%fn)
	,	Point2 	= ((k+2)%slices)*fn+	(k==slices-1 ? (fn+fn/2-j  )%fn : j)
	,	v1 = points[Point1p]-points[Point0]
	,	v2 = points[Point1m]-points[Point0]
	,	v = cross(v1,v2)
	,	n = norm(v)*0.66
	)
	color("gainsboro")
	translate(points[Point0]+v*0.04)
	multmatrix(
	[[n,0,0]
	,[0,n,0]
	,[0,0,n]])
	multmatrix(rotate_from_to([0,0,1],v))
	polyhedron([[0,0,0], for(k=[0:fn]) Circle[k]], [[0, for(k=[0:fn/2-4]) (fn/2+k+j+3)%fn+1]]);

//	Klein_Cygnet_Preening is licensed under
//	MIT License
//
//	Copyright (c) 2023 DrT0M
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//	
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
}

//tab stop @ 8

// OpenSCAD User Manual/Tips and Tricks Minimum rotation problem
// Find the unitary vector with direction v. Fails if v=[0,0,0].
function unit(v) = norm(v)>0 ? v/norm(v) : undef;
// Find the transpose of a rectangular matrix
function transpose(m) = // m is any rectangular matrix of objects
[ for(j=[0:len(m[0])-1]) [ for(i=[0:len(m)-1]) m[i][j] ] ];
// The identity matrix with dimension n
function identity(n) = [for(i=[0:n-1]) [for(j=[0:n-1]) i==j ? 1 : 0] ];
// computes the rotation with minimum angle that brings a to b
// the code fails if a and b are opposed to each other
function rotate_from_to(a,b) =
let( axis = unit(cross(a,b)) )
axis*axis >= 0.99 ?
transpose([unit(b), axis, cross(axis, unit(b))]) *
[unit(a), axis, cross(axis, unit(a))] :
identity(3);
