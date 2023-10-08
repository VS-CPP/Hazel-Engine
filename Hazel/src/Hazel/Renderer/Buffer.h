#pragma once


namespace Hazel
{
	
	class VertexBuffer
	{
	public:
		virtual ~VertexBuffer() {}


		virtual void Bind() const = 0;
		virtual void Unbind() const = 0;

		/* we can not set Constructor in Pure Abstract class 
		   so static func() is a method to pass data */
		static VertexBuffer* Create(float* vertices, uint32_t size);
	};



	class IndexBuffer
	{
	public:
		virtual ~IndexBuffer() {}

		virtual void Bind() const = 0;
		virtual void Unbind() const = 0;

		virtual uint32_t GetCount() const = 0;

		/* we can not set Constructor in Pure Abstract class
		   so static func() is a method to pass data */
		static IndexBuffer* Create(uint32_t* indices, uint32_t size);
	};

}